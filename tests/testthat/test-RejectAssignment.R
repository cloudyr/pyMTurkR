
test_that("RejectAssignment", {
  skip_if_not(CheckAWSKeys())
  skip_if(nrow(try(GetAssignment(hit.type = '3ZY5FK1Q9GOM4W6XMFN2W6BL58VO8Z',
                                 status = 'Submitted',
                                 results = 1), TRUE)) == 0)

  GetAssignment(hit.type = '3ZY5FK1Q9GOM4W6XMFN2W6BL58VO8Z',
                status = 'Submitted',
                results = 1)$AssignmentId -> assignment

  expect_type(RejectAssignment(assignments = assignment,
                               feedback = as.factor('Failed test'),
                               verbose = FALSE), "list")

  # Feedback that's too long (more than 1024 characters)
  expect_s3_class(try(RejectAssignment(assignments = assignment,
                                verbose = FALSE,
                                feedback = paste(sample(LETTERS, 1025, replace=TRUE), collapse="")), TRUE), "try-error")

  # More feedbacks than assignments should give try-error
  expect_s3_class(try(RejectAssignment(assignments = assignment,
                                        verbose = FALSE,
                                        feedback = c("a", "b")), TRUE), "try-error")

  # More rejected logicals than assignments should give try-error
  expect_s3_class(try(RejectAssignment(assignments = assignment,
                                        verbose = FALSE,
                                        rejected = c(TRUE, FALSE)), TRUE), "try-error")

})
