
test_that("ApproveAssignment with AssignmentId", {
  skip_if_not(CheckAWSKeys())
  skip_if(nrow(try(GetAssignment(hit.type = '3ZY5FK1Q9GOM4W6XMFN2W6BL58VO8Z',
                                 results = 1,
                                 status = 'Submitted'), TRUE)) == 0)

  GetAssignment(hit.type = '3ZY5FK1Q9GOM4W6XMFN2W6BL58VO8Z',
                results = 1,
                status = 'Submitted')$AssignmentId -> assignment

  expect_type(ApproveAssignment(assignments = assignment, verbose = FALSE), "list")
})


test_that("ApproveAssignment with AssignmentId and feedback", {
  skip_if_not(CheckAWSKeys())
  skip_if(nrow(try(GetAssignment(hit.type = '3ZY5FK1Q9GOM4W6XMFN2W6BL58VO8Z',
                                 results = 1,
                                 status = 'Submitted'), TRUE)) == 0)

  GetAssignment(hit.type = '3ZY5FK1Q9GOM4W6XMFN2W6BL58VO8Z',
                results = 1,
                status = 'Submitted')$AssignmentId -> assignment

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
  skip_if(nrow(try(GetAssignment(hit.type = '3ZY5FK1Q9GOM4W6XMFN2W6BL58VO8Z',
                                 results = 1,
                                 status = 'Submitted'), TRUE)) == 0)

  GetAssignment(hit.type = '3ZY5FK1Q9GOM4W6XMFN2W6BL58VO8Z',
                results = 1,
                status = 'Submitted')$AssignmentId -> assignment

  # Rejected
  expect_type(ApproveAssignment(assignments = assignment,
                                rejected = TRUE), "list")

  # More rejected logicals than assignments should give try-error
  expect_s3_class(try(ApproveAssignment(assignments = assignment,
                                          verbose = FALSE,
                                          rejected = c(TRUE, FALSE)), TRUE), "try-error")

})
