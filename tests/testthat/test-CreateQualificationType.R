
test_that("CreateQualificationType with minimal info", {
  skip_if_not(CheckAWSKeys())

  CreateQualificationType(name = "Qual0001",
                          description = "This is a qualification",
                          status = "Active",
                          auto = TRUE,
                          auto.value = 1,
                          retry.delay = 30) -> qual
  expect_type(qual, "list")

  # Delete qual
  DeleteQualificationType(qual$QualificationTypeId)
})



test_that("CreateQualificationType with Qualification Test", {
  skip_if_not(CheckAWSKeys())

  f <- system.file("templates/qualificationtest1.xml", package = "pyMTurkR")
  QuestionForm <- paste0(readLines(f, warn = FALSE), collapse = "")
  f <- system.file("templates/answerkey1.xml", package = "pyMTurkR")
  AnswerKey <- paste0(readLines(f, warn = FALSE), collapse = "")

  CreateQualificationType(name = "Qual0001",
                          description = "This is a qualification",
                          status = "Active",
                          test = QuestionForm,
                          test.duration = 30,
                          answerkey = AnswerKey) -> qual
  expect_type(qual, "list")

  # Delete qual
  DeleteQualificationType(qual$QualificationTypeId)
})



test_that("CreateQualificationType with parameter misspecification", {
  skip_if_not(CheckAWSKeys())

  f <- system.file("templates/qualificationtest1.xml", package = "pyMTurkR")
  QuestionForm <- paste0(readLines(f, warn = FALSE), collapse = "")
  f <- system.file("templates/answerkey1.xml", package = "pyMTurkR")
  AnswerKey <- paste0(readLines(f, warn = FALSE), collapse = "")

  # Specified test, missing test.duration
  try(CreateQualificationType(name = "Qual0001",
                          description = "This is a qualification",
                          status = "Active",
                          test = QuestionForm), TRUE) -> qual
  expect_s3_class(qual, "try-error")

  # Specified test.duration, missing test
  try(CreateQualificationType(name = "Qual0001",
                              description = "This is a qualification",
                              status = "Active",
                              test.duration = 30), TRUE) -> qual
  expect_s3_class(qual, "try-error")

  # Specified answerkey, missing test
  try(CreateQualificationType(name = "Qual0001",
                              description = "This is a qualification",
                              status = "Active",
                              answerkey = AnswerKey), TRUE) -> qual
  expect_s3_class(qual, "try-error")

  # Auto is not logical
  try(CreateQualificationType(name = "Qual0001",
                              description = "This is a qualification",
                              status = "Active",
                              auto = "x"), TRUE) -> qual
  expect_s3_class(qual, "try-error")

  # Auto value is not integer
  try(CreateQualificationType(name = "Qual0001",
                              description = "This is a qualification",
                              status = "Active",
                              auto = TRUE,
                              auto.value = 'x'), TRUE) -> qual
  expect_s3_class(qual, "try-error")

  # Retry delay is not integer
  try(CreateQualificationType(name = "Qual0001",
                              description = "This is a qualification",
                              status = "Active",
                              retry.delay = 'x'), TRUE) -> qual
  expect_s3_class(qual, "try-error")

})


