
test_that("ApproveAssignment with AssignmentId", {
  skip_if_not(CheckAWSKeys())

  # Fetch hit, then get assignment ID
  SearchHITs() -> hits
  hits$HITs$HITId[[1]] -> hit
  GetAssignment(hit = hit) -> assignment

  expect_type(ApproveAssignment(assignments = assignment$AssignmentId, verbose = FALSE), "list")
})


test_that("ApproveAssignment with AssignmentId and feedback", {
  skip_if_not(CheckAWSKeys())
  SearchHITs() -> hits
  hits$HITs$HITId[[1]] -> hit
  GetAssignment(hit = hit) -> assignment

  # Character feedback
  expect_type(ApproveAssignment(assignments = assignment$AssignmentId,
                                verbose = FALSE,
                                feedback = "good job"), "list")

  # Factor feedback
  expect_type(ApproveAssignment(assignments = assignment$AssignmentId,
                                verbose = FALSE,
                                feedback = as.factor("good job")), "list")

  # Feedback that's too long (more than 1024 characters)
  expect_type(ApproveAssignment(assignments = assignment$AssignmentId,
                                verbose = FALSE,
                                feedback = paste(sample(LETTERS, 1025, replace=TRUE), collapse="")), "list")

  # Fewer feedbacks than assignments
  expect_type(ApproveAssignment(assignments = c(assignment$AssignmentId, assignment$AssignmentId),
                                verbose = FALSE,
                                feedback = "good job"), "list")

  # More feedbacks than assignments should give try-error
  expect_type(class(try(ApproveAssignment(assignments = assignment$AssignmentId,
                                          verbose = FALSE,
                                          feedback = c("a", "b")))), "try-error")


})


test_that("ApproveAssignment with rejected parameter", {
  skip_if_not(CheckAWSKeys())
  SearchHITs() -> hits
  hits$HITs$HITId[[1]] -> hit
  GetAssignment(hit = hit) -> assignment

  # Rejected
  expect_type(ApproveAssignment(assignments = assignment$AssignmentId,
                                rejected = TRUE), "list")

  # More rejected logicals than assignments should give try-error
  expect_type(class(try(ApproveAssignment(assignments = assignment$AssignmentId,
                                          verbose = FALSE,
                                          rejected = c(TRUE, FALSE)))), "try-error")

})
