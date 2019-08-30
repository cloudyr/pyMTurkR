
test_that("ExtendHIT using HITId, HITTypeId, Annotation", {
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

  # Extend HIT using HITId
  ExtendHIT(hit = hit$HITId,
            add.assignments = "1",
            add.seconds = seconds(days=1),
            unique.request.token = as.character(runif(1, 1, 99999999))) -> extend
  expect_type(extend, "list")

  # Extend HIT using HITTypeId
  set.seed(as.integer(Sys.time()))
  ExtendHIT(hit.type = hit$HITTypeId,
            add.assignments = "1",
            add.seconds = seconds(days=1),
            unique.request.token = as.character(runif(1, 1, 99999999))) -> extend
  expect_type(extend, "list")

  # Extend HIT using Annotation
  set.seed(as.integer(Sys.time()))
  ExtendHIT(annotation = 'my_annotation',
            add.assignments = "1",
            add.seconds = seconds(days=1),
            unique.request.token = as.character(runif(1, 1, 99999999))) -> extend
  expect_type(extend, "list")

  # Delete HIT
  ExpireHIT(hit$HITId,
            approve.pending.assignments = TRUE,
            verbose = FALSE)
  DeleteHIT(hit$HITId,
            skip.delete.prompt = TRUE,
            verbose = FALSE)
})




test_that("ExtendHIT with parameter misspecifications", {
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

  # Missing any extension parameters
  try(ExtendHIT(hit = hit$HITId)) -> extend
  expect_s3_class(extend, "try-error")

  # Add assignments is not integer
  try(ExtendHIT(hit = hit$HITId, add.assignments = 'x')) -> extend
  expect_s3_class(extend, "try-error")

  # Add assignments is zero
  try(ExtendHIT(hit = hit$HITId, add.assignments = 0)) -> extend
  expect_s3_class(extend, "try-error")

  # Add seconds is not integer
  try(ExtendHIT(hit = hit$HITId, add.seconds = 'x')) -> extend
  expect_s3_class(extend, "try-error")

  # Add seconds is zero
  try(ExtendHIT(hit = hit$HITId, add.seconds = 0)) -> extend
  expect_s3_class(extend, "try-error")

  # Missing hit
  try(ExtendHIT(add.seconds = seconds(days=1))) -> extend
  expect_s3_class(extend, "try-error")

  # Nothing found
  try(ExtendHIT(annotation = "NOTANANNOTATION", add.seconds = seconds(days=1))) -> extend
  expect_s3_class(extend, "try-error")

  # Delete HIT
  ExpireHIT(hit$HITId,
            approve.pending.assignments = TRUE,
            verbose = FALSE)
  DeleteHIT(hit$HITId,
            skip.delete.prompt = TRUE,
            verbose = FALSE)
})



