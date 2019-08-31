test_that("GenerateHITReviewPolicy", {
  lista <- list(QuestionIds = c("Question1", "Question2"),
                QuestionAgreementThreshold = 75,
                ApproveIfWorkerAgreementScoreIsAtLeast = 75,
                RejectIfWorkerAgreementScoreIsLessThan = 25)
  policya <- do.call(GenerateHITReviewPolicy, lista)
  expect_equal(class(policya)[1], "python.builtin.dict")
})


test_that("GenerateHITReviewPolicy errors", {

  # Missing ExtendMaximumAssignments and ExtendMinimumTimeInSeconds
  lista <- list(QuestionIds = c("Question1", "Question2"),
                QuestionAgreementThreshold = 75,
                ApproveIfWorkerAgreementScoreIsAtLeast = 75,
                RejectIfWorkerAgreementScoreIsLessThan = 25,
                ExtendIfHITAgreementScoreIsLessThan = 25)
  policya <- try(do.call(GenerateHITReviewPolicy, lista))
  expect_s3_class(policya, "try-error")


  # ExtendIfHITAgreementScoreIsLessThan must be between 0 and 100
  lista <- list(QuestionIds = c("Question1", "Question2"),
                QuestionAgreementThreshold = 75,
                ApproveIfWorkerAgreementScoreIsAtLeast = 75,
                RejectIfWorkerAgreementScoreIsLessThan = 25,
                ExtendIfHITAgreementScoreIsLessThan = -1,
                ExtendMaximumAssignments = 1,
                ExtendMinimumTimeInSeconds = 1)
  policya <- try(do.call(GenerateHITReviewPolicy, lista))
  expect_s3_class(policya, "try-error")


  # DisregardAssignmentIfRejected must be true or false
  lista <- list(QuestionIds = c("Question1", "Question2"),
                QuestionAgreementThreshold = 75,
                ApproveIfWorkerAgreementScoreIsAtLeast = 75,
                RejectIfWorkerAgreementScoreIsLessThan = 25,
                DisregardAssignmentIfRejected = 'x')
  policya <- try(do.call(GenerateHITReviewPolicy, lista))
  expect_s3_class(policya, "try-error")


  # Missing QuestionIds
  lista <- list(QuestionAgreementThreshold = 75,
                ApproveIfWorkerAgreementScoreIsAtLeast = 75,
                RejectIfWorkerAgreementScoreIsLessThan = 25)
  policya <- try(do.call(GenerateHITReviewPolicy, lista))
  expect_s3_class(policya, "try-error")


  # Inappropriate parameter
  lista <- list(QuestionIds = "Question1",
                X = 75)
  policya <- try(do.call(GenerateHITReviewPolicy, lista))
  expect_s3_class(policya, "try-error")
})





test_that("GenerateAssignmentReviewPolicy", {
  # Generate an Assignment Review Policy with GenerateAssignmentReviewPolicy
  listb <- list(AnswerKey = list("QuestionId1" = "B", "QuestionId2" = "A"),
                ApproveIfKnownAnswerScoreIsAtLeast = 99)
  policyb <- do.call(GenerateAssignmentReviewPolicy, listb)
  expect_equal(class(policyb)[1], "python.builtin.dict")
})




test_that("GenerateAssignmentReviewPolicy errors", {

  # ApproveIfKnownAnswerScoreIsAtLeast must be between 0 and 101
  listb <- list(AnswerKey = list("QuestionId1" = "B", "QuestionId2" = "A"),
                ApproveIfKnownAnswerScoreIsAtLeast = 102)
  policyb <- try(do.call(GenerateAssignmentReviewPolicy, listb))
  expect_s3_class(policyb, "try-error")

  # RejectIfKnownAnswerScoreIsLessThan must be between 0 and 101
  listb <- list(AnswerKey = list("QuestionId1" = "B", "QuestionId2" = "A"),
                ApproveIfKnownAnswerScoreIsAtLeast = 99,
                RejectIfKnownAnswerScoreIsLessThan = 102)
  policyb <- try(do.call(GenerateAssignmentReviewPolicy, listb))
  expect_s3_class(policyb, "try-error")


  # ExtendIfKnownAnswerScoreIsLessThan must be between 0 and 101
  listb <- list(AnswerKey = list("QuestionId1" = "B", "QuestionId2" = "A"),
                ApproveIfKnownAnswerScoreIsAtLeast = 99,
                ExtendIfKnownAnswerScoreIsLessThan = 102)
  policyb <- try(do.call(GenerateAssignmentReviewPolicy, listb))
  expect_s3_class(policyb, "try-error")


  # ExtendMaximumAssignments must be between 2 and 25
  listb <- list(AnswerKey = list("QuestionId1" = "B", "QuestionId2" = "A"),
                ApproveIfKnownAnswerScoreIsAtLeast = 99,
                ExtendMaximumAssignments = 102)
  policyb <- try(do.call(GenerateAssignmentReviewPolicy, listb))
  expect_s3_class(policyb, "try-error")


  # ExtendMinimumTimeInSeconds must be between 1 hour and 1 year
  listb <- list(AnswerKey = list("QuestionId1" = "B", "QuestionId2" = "A"),
                ApproveIfKnownAnswerScoreIsAtLeast = 99,
                ExtendMinimumTimeInSeconds = 1)
  policyb <- try(do.call(GenerateAssignmentReviewPolicy, listb))
  expect_s3_class(policyb, "try-error")


  # Missing Answer Key
  listb <- list(ApproveIfKnownAnswerScoreIsAtLeast = 99)
  policyb <- try(do.call(GenerateAssignmentReviewPolicy, listb))
  expect_s3_class(policyb, "try-error")


  # Inappropriate parameter
  listb <- list(AnswerKey = list("QuestionId1" = "B", "QuestionId2" = "A"),
                ApproveIfKnownAnswerScoreIsAtLeast = 99,
                X = 1)
  policyb <- try(do.call(GenerateAssignmentReviewPolicy, listb))
  expect_s3_class(policyb, "try-error")

})

