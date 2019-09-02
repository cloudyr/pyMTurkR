test_that("UpdateQualificationType", {
  skip_if_not(CheckAWSKeys())

  qual1 <- CreateQualificationType(name = "Qual002",
                                   description = "Qual002",
                                   status = "Active",
                                   keywords = "Worked for me before")

  result <- UpdateQualificationType(qual1$QualificationTypeId,
                                    description = "This qualification is for everybody!",
                                    status = "Active",
                                    auto = TRUE,
                                    auto.value = 1,
                                    retry.delay = 30)
  expect_type(result, "list")

  DisposeQualificationType(qual1$QualificationTypeId)
})



test_that("UpdateQualificationType with Qualification Test", {

  f <- system.file("templates/qualificationtest1.xml", package = "pyMTurkR")
  QuestionForm <- paste0(readLines(f, warn = FALSE), collapse = "")
  f <- system.file("templates/answerkey1.xml", package = "pyMTurkR")
  AnswerKey <- paste0(readLines(f, warn = FALSE), collapse = "")

  CreateQualificationType(name = "Qual002",
                          description = "Qual002",
                          status = "Active",
                          test = QuestionForm,
                          test.duration = 30) -> qual

  # Add an AnswerKey
  result <- UpdateQualificationType(qual$QualificationTypeId,
                                    answerkey = AnswerKey,
                                    test = QuestionForm,
                                    test.duration = 30)
  expect_type(result, "list")

})
