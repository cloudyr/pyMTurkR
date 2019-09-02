
test_that("CreateHIT", {
  skip_if_not(CheckAWSKeys())

  ####################
  # Register a HIT type
  set.seed(as.integer(Sys.time()))
  hittype1 <- RegisterHITType(title =  paste0("10 Question Survey",
                                              as.character(runif(1, 1, 99999999))),
                              description = "Complete a 10-question survey",
                              reward = ".20",
                              duration = seconds(hours=1),
                              keywords = "survey, questionnaire, politics")

  # Create a HIT using the HIT type just created
  a <- GenerateExternalQuestion("https://www.example.com", "400")
  hit <- CreateHIT(hit.type = hittype1$HITTypeId,
                   assignments = 1,
                   expiration = seconds(days=1),
                   question = a$string,
                   annotation = 'my_annotation',
                   auto.approval.delay = 30)
  expect_type(hit, "list")


  ####################
  # Register a HIT type
  set.seed(as.integer(Sys.time()))
  hittype1 <- RegisterHITType(title =  paste0("10 Question Survey",
                                              as.character(runif(1, 1, 99999999))),
                              description = "Complete a 10-question survey",
                              reward = ".20",
                              duration = seconds(hours=1),
                              keywords = "survey, questionnaire, politics")

  # Generate a HIT policy
  lista <- list(QuestionIds = c("Question1", "Question2"),
                QuestionAgreementThreshold = 75,
                ApproveIfWorkerAgreementScoreIsAtLeast = 75,
                RejectIfWorkerAgreementScoreIsLessThan = 25)
  policya <- do.call(GenerateHITReviewPolicy, lista)

  # Generate an assignment policy
  listb <- list(AnswerKey = list("QuestionId1" = "B", "QuestionId2" = "A"),
                ApproveIfKnownAnswerScoreIsAtLeast = 99)
  policyb <- do.call(GenerateAssignmentReviewPolicy, listb)

  # Create a HIT using the HIT type and policies just created
  a <- GenerateExternalQuestion("https://www.example.com", "400")
  hit2 <- CreateHIT(hit.type = hittype1$HITTypeId,
                    assignments = 1,
                    expiration = seconds(days=1),
                    question = a$string,
                    annotation = 'my_annotation',
                    hit.review.policy = policya,
                    assignment.review.policy = policyb,
                    auto.approval.delay = 30)
  expect_type(hit2, "list")

  ########################
  # Using hitlayoutid and hitlayoutparameters
  hit3 <- CreateHIT(hit.type = '3ZY5FK1Q9GOM4W6XMFN2W6BL58VO8Z',
                    hitlayoutid = '3NT7VIEMIJ1I0VN7L8GIWYJN5TUZPK',
                    hitlayoutparameters = list(
                      list(
                        Name = 'filler',
                        Value = '1'
                      )
                    ),
                    assignments = 1,
                    expiration = seconds(days=1),
                    hit.review.policy = policya,
                    assignment.review.policy = policyb,
                    auto.approval.delay = 30)


  Sys.sleep(15)

  # Delete HIT
  ExpireHIT(hit$HITId,
            verbose = FALSE)
  DeleteHIT(hit$HITId,
            skip.delete.prompt = TRUE,
            verbose = FALSE)

  # Delete HIT
  ExpireHIT(hit2$HITId,
            verbose = FALSE)
  DeleteHIT(hit2$HITId,
            skip.delete.prompt = TRUE,
            verbose = FALSE)
})





test_that("CreateHIT with incorrect parameters", {
  skip_if_not(CheckAWSKeys())

  # Register a HIT type
  set.seed(as.integer(Sys.time()))
  hittype1 <- RegisterHITType(title =  paste0("10 Question Survey",
                                              as.character(runif(1, 1, 99999999))),
                              description = "Complete a 10-question survey",
                              reward = ".20",
                              duration = seconds(hours=1),
                              keywords = "survey, questionnaire, politics")

  # Create a HIT using the HIT type just created
  a <- GenerateExternalQuestion("https://www.example.com", "400")

  # Too many assignments
  expect_s3_class(try(CreateHIT(hit.type = hittype1$HITTypeId,
                            assignments = 1000000001,
                            expiration = seconds(days=1),
                            question = a$string), TRUE), "try-error")

  # No hit.type and missing everything else
  expect_s3_class(try(CreateHIT(assignments = 1), TRUE), "try-error")

  # Title has too many characters
  expect_s3_class(try(CreateHIT(assignments = 1,
                                title = paste(rep("A", 129), collapse = ""),
                                description = 'Description',
                                duration = seconds(hours=1),
                                reward = 0), TRUE), "try-error")

  # Description has too many characters
  expect_s3_class(try(CreateHIT(assignments = 1,
                                title = 'Title',
                                description = paste(rep("A", 2001), collapse = ""),
                                duration = seconds(hours=1),
                                reward = 0), TRUE), "try-error")

  # Duration is too short
  expect_s3_class(try(CreateHIT(assignments = 1,
                                title = 'Title',
                                description = 'Description',
                                duration = 1,
                                reward = 0), TRUE), "try-error")

  # Reward is missing a leading zero, keywords has too many characters
  expect_s3_class(try(CreateHIT(assignments = 1,
                                title = 'Title',
                                description = 'Description',
                                duration = 30,
                                reward = '.1',
                                keywords = paste(rep("A", 1001), collapse = "")), TRUE), "try-error")

  # Assignments is NULL
  expect_s3_class(try(CreateHIT(title = 'Title',
                                description = 'Description',
                                duration = 30,
                                reward = '.1'), TRUE), "try-error")

  # Approval delay is too long
  expect_s3_class(try(CreateHIT(assignments = 1,
                                title = 'Title',
                                description = 'Description',
                                duration = 30,
                                reward = '.1',
                                auto.approval.delay = 2592001), TRUE), "try-error")

  # Missing question / hitlayoutid
  expect_s3_class(try(CreateHIT(hit.type = hittype1$HITTypeId,
                                assignments = 1,
                                expiration = seconds(days=1)), TRUE), "try-error")

  # Missing expiration
  expect_s3_class(try(CreateHIT(hit.type = hittype1$HITTypeId,
                                assignments = 1,
                                question = a$string), TRUE), "try-error")

  # Expiration too short
  expect_s3_class(try(CreateHIT(hit.type = hittype1$HITTypeId,
                                assignments = 1,
                                expiration = 1,
                                question = a$string), TRUE), "try-error")

  # Annotation too long
  expect_s3_class(try(CreateHIT(hit.type = hittype1$HITTypeId,
                                assignments = 1,
                                expiration = 30,
                                annotation = paste(rep("A", 256), collapse = ""),
                                question = a$string), TRUE), "try-error")

  # Unique request token too long
  expect_s3_class(try(CreateHIT(hit.type = hittype1$HITTypeId,
                                assignments = 1,
                                expiration = 30,
                                unique.request.token = paste(rep("A", 65), collapse = ""),
                                question = a$string), TRUE), "try-error")
})


