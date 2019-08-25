
test_that("ApproveAssignment with AssignmentId", {
  skip_if_not(CheckAWSKeys())

  # Fetch hit, then get assignment ID
  GetReviewableHITs() -> hits
  hits$HITId[[1]] -> hit
  GetAssignment(hit = hit)[[1]][1] -> assignment

  expect_type(ApproveAssignment(assignments = assignment, verbose = FALSE), "list")
})


test_that("ApproveAssignment with AssignmentId and feedback", {
  skip_if_not(CheckAWSKeys())

  GetReviewableHITs() -> hits
  hits$HITId[[1]] -> hit
  GetAssignment(hit = hit)[[1]][1] -> assignment

  # Character feedback
  expect_type(ApproveAssignment(assignments = assignment,
                                verbose = FALSE,
                                feedback = "good job"), "list")

  # Factor feedback
  expect_type(ApproveAssignment(assignments = assignment,
                                verbose = FALSE,
                                feedback = as.factor("good job")), "list")

  # Feedback that's too long (more than 1024 characters)
  expect_type(ApproveAssignment(assignments = assignment,
                                verbose = FALSE,
                                feedback = paste(sample(LETTERS, 1025, replace=TRUE), collapse="")), "list")

  # Fewer feedbacks than assignments
  expect_type(ApproveAssignment(assignments = c(assignment, assignment),
                                verbose = FALSE,
                                feedback = "good job"), "list")

  # More feedbacks than assignments should give try-error
  expect_s3_class(try(ApproveAssignment(assignments = assignment,
                                          verbose = FALSE,
                                          feedback = c("a", "b")), TRUE), "try-error")


})


test_that("ApproveAssignment with rejected parameter", {
  skip_if_not(CheckAWSKeys())

  GetReviewableHITs() -> hits
  hits$HITId[[1]] -> hit
  GetAssignment(hit = hit)[[1]][1] -> assignment

  # Rejected
  expect_type(ApproveAssignment(assignments = assignment,
                                rejected = TRUE), "list")

  # More rejected logicals than assignments should give try-error
  expect_s3_class(try(ApproveAssignment(assignments = assignment,
                                          verbose = FALSE,
                                          rejected = c(TRUE, FALSE)), TRUE), "try-error")

})
