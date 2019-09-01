
test_that("DisableHIT", {
  skip_if_not(CheckAWSKeys())

  #################
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


  #################
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
  hit2 <- CreateHIT(hit.type = hittype1$HITTypeId,
                   assignments = 1,
                   expiration = seconds(days=1),
                   question = a$string,
                   annotation = 'my_annotation',
                   auto.approval.delay = 30)


  #################
  # Register a HIT type
  set.seed(as.integer(Sys.time()))
  hittype2 <- RegisterHITType(title =  paste0("10 Question Survey",
                                              as.character(runif(1, 1, 99999999))),
                              description = "Complete a 10-question survey",
                              reward = ".20",
                              duration = seconds(hours=1),
                              keywords = "survey, questionnaire, politics")

  # Create a HIT using the HIT type just created
  annotation <- paste0('x', as.character(runif(1, 1, 99999999)))
  a <- GenerateExternalQuestion("https://www.example.com", "400")
  hit3 <- CreateHIT(hit.type = hittype2$HITTypeId,
                   assignments = 1,
                   expiration = seconds(days=1),
                   question = a$string,
                   annotation = annotation,
                   auto.approval.delay = 30)

  Sys.sleep(15)

  #################
  # Expire, Delete HIT by HITId
  ExpireHIT(hit$HITId,
            verbose = FALSE) -> expire
  DeleteHIT(hit$HITId,
            skip.delete.prompt = TRUE,
            verbose = FALSE) -> delete

  expect_type(expire, "list")
  expect_type(delete, "list")

  # Expire, Delete HIT by HITType
  ExpireHIT(hit.type = hit2$HITTypeId,
            verbose = FALSE) -> expire2
  DeleteHIT(hit.type = hit2$HITTypeId,
            skip.delete.prompt = TRUE,
            verbose = FALSE) -> delete2

  expect_type(expire2, "list")
  expect_type(delete2, "list")


  # Expire, Delete HIT by Annotation
  ExpireHIT(annotation = annotation,
            verbose = FALSE) -> expire3
  DeleteHIT(annotation = annotation,
            skip.delete.prompt = TRUE,
            verbose = FALSE) -> delete3

  expect_type(expire3, "list")
  expect_type(delete3, "list")
})


test_that("DisableHIT but none found", {
  skip_if_not(CheckAWSKeys())

  # Expire, Delete HIT by HITId
  try(ExpireHIT(annotation = 'NotAnAnnotation',
            verbose = FALSE), TRUE) -> expire

  expect_s3_class(expire, "try-error")
})
