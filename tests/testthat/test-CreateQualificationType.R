
test_that("CreateQualificationType with minimal info", {
  skip_if_not(CheckAWSKeys())

  CreateQualificationType(name = "Qual0001",
                          description = "This is a qualification",
                          status = "Active") -> qual
  expect_type(qual, "list")

  # Delete qual
  DeleteQualificationType(qual$QualificationTypeId)
})



test_that("CreateQualificationType with Qualification Test", {
  skip_if_not(CheckAWSKeys())

  f <- system.file("templates/qualificationtest1.xml", package = "pyMTurkR")
  QuestionForm <- paste0(readLines(f, warn = FALSE), collapse = "")

  CreateQualificationType(name = "Qual0001",
                          description = "This is a qualification",
                          status = "Active",
                          test = QuestionForm,
                          test.duration = 30) -> qual
  expect_type(qual, "list")

  # Delete qual
  DeleteQualificationType(qual$QualificationTypeId)
})




