
test_that("DisableHIT using HITId", {
  skip_if_not(CheckAWSKeys())

  # Register a HIT type
  hittype1 <- RegisterHITType(title = "10 Question Survey",
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

  Sys.sleep(15)

  # Expire, Delete HIT by HITId
  ExpireHIT(hit$HITId,
            approve.pending.assignments = TRUE,
            verbose = FALSE) -> expire
  DeleteHIT(hit$HITId,
            skip.delete.prompt = TRUE,
            verbose = FALSE) -> delete

  expect_type(expire, "list")
  expect_type(delete, "list")
})




test_that("DisableHIT using HITType", {
  skip_if_not(CheckAWSKeys())

  # Register a HIT type
  hittype1 <- RegisterHITType(title = "10 Question Survey",
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

  Sys.sleep(15)

  # Expire, Delete HIT by HITType
  ExpireHIT(hit.type = hit$HITTypeId,
            approve.pending.assignments = TRUE,
            verbose = FALSE) -> expire
  DeleteHIT(hit.type = hit$HITTypeId,
            skip.delete.prompt = TRUE,
            verbose = FALSE) -> delete

  expect_type(expire, "list")
  expect_type(delete, "list")
})




test_that("DisableHIT using Annotation", {
  skip_if_not(CheckAWSKeys())

  # Register a HIT type
  hittype1 <- RegisterHITType(title = "10 Question Survey",
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

  Sys.sleep(15)

  # Expire, Delete HIT by Annotation
  ExpireHIT(annotation = 'my_annotation',
            approve.pending.assignments = TRUE,
            verbose = FALSE) -> expire
  DeleteHIT(annotation = 'my_annotation',
            skip.delete.prompt = TRUE,
            verbose = FALSE) -> delete

  expect_type(expire, "list")
  expect_type(delete, "list")
})



test_that("DisableHIT but none found", {
  skip_if_not(CheckAWSKeys())

  # Expire, Delete HIT by HITId
  try(ExpireHIT(annotation = 'NotAnAnnotation',
            approve.pending.assignments = TRUE,
            verbose = FALSE)) -> expire

  expect_s3_class(expire, "try-error")
})
