
test_that("ChangeHITType using RegisterHITType", {
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
  hit <- CreateHIT(hit.type = as.factor(hittype1$HITTypeId),
                   assignments = 1,
                   expiration = seconds(days=1),
                   question = a$string)

  # Register a second HIT type
  set.seed(as.integer(Sys.time()))
  hittype2 <- RegisterHITType(title =  paste0("10 Question Survey",
                                              as.character(runif(1, 1, 99999999))),
                              description = "Complete a 10-question survey",
                              reward = ".20",
                              duration = seconds(hours=1),
                              keywords = "survey, questionnaire, politics")


  ####################
  # Register a HIT type
  set.seed(as.integer(Sys.time()))
  hittype3 <- RegisterHITType(title =  paste0("10 Question Survey",
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
                   question = a$string)


  #####################
  Sys.sleep(15)

  # HIT 1
  # Now change the HIT type of the HIT created previously
  expect_type(ChangeHITType(hit = hit$HITId, new.hit.type = hittype2$HITTypeId), "list")

  # as.factor
  expect_type(ChangeHITType(hit = as.factor(hit$HITId), new.hit.type = hittype2$HITTypeId), "list")

  # Title ignored
  expect_type(ChangeHITType(hit = as.factor(hit$HITId), new.hit.type = hittype2$HITTypeId, title = 'x'), "list")


  # HIT 2
  # Define new HIT type in function call to change it to
  expect_type(ChangeHITType(hit = hit2$HITId,
                            title =  paste0("10 Question Survey",
                                            as.character(runif(1, 1, 99999999))),
                            description = "Complete a 10-question survey",
                            reward = ".45",
                            duration = seconds(hours=1),
                            auto.approval.delay = 1,
                            keywords = "survey, questionnaire, politics"), "list")


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



test_that("ChangeHITType using new HIT Type defined in function", {
  skip_if_not(CheckAWSKeys())

  # Register a HIT type
  set.seed(as.integer(Sys.time()))
  hittype1 <- RegisterHITType(title =  paste0("10 Question Survey",
                                              as.character(runif(1, 1, 99999999))),
                              description = "Complete a 10-question survey",
                              reward = ".20",
                              duration = seconds(hours=1),
                              keywords = "survey, questionnaire, politics")

  # Get Old HIT to change
  SearchHITs() -> hits
  tail(hits$HITs$HITTypeId, 1) -> old.hit.type
  tail(hits$HITs$RequesterAnnotation[!is.na(hits$HITs$RequesterAnnotation)], 1) -> old.annotation

  # Change HITs matching Old HIT Type to New HIT Type
  expect_type(ChangeHITType(old.hit.type = old.hit.type,
                            new.hit.type = hittype1$HITTypeId), "list")

  # Change HITs matching Old HIT Annotation to New HIT Type
  expect_type(ChangeHITType(old.annotation = old.annotation,
                            new.hit.type = hittype1$HITTypeId), "list")

  # Change HITs matching Old HIT Annotation to New HIT Type
  expect_type(ChangeHITType(old.annotation = old.annotation,
                            new.hit.type = hittype1$HITTypeId), "list")


})
