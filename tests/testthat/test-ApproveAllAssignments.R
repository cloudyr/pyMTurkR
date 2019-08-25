
test_that("ApproveAllAssignments with more than one feedback", {
  skip_if_not(CheckAWSKeys())
  expect_s3_class(try(ApproveAllAssignments(hit = 'NOTAHIT', feedback = c("1", "2")), TRUE), "try-error")
})


test_that("ApproveAllAssignments with missing parameters", {
  skip_if_not(CheckAWSKeys())
  expect_s3_class(try(ApproveAllAssignments(), TRUE), "try-error")
})


test_that("ApproveAllAssignments with hit.type", {
  skip_if_not(CheckAWSKeys())

  # Get HITs then HIT Type
  GetReviewableHITs() -> hits
  hits$HITId[[1]] -> hit
  GetHIT(hit) -> hit
  hit$HITs$HITTypeId[[1]] -> hit.type

  expect_type(ApproveAllAssignments(hit.type = hit.type, verbose = FALSE), "list")
})


test_that("ApproveAllAssignments with hit", {
  skip_if_not(CheckAWSKeys())

  # Get HITs then HIT Type
  GetReviewableHITs() -> hits
  hits$HITId[[1]] -> hit

  expect_type(ApproveAllAssignments(hit = hit), "list")
})


test_that("ApproveAllAssignments with feedback that's too long", {
  skip_if_not(CheckAWSKeys())

  # Get HITs then Assignment
  GetReviewableHITs() -> hits
  hits$HITId[[1]] -> hit
  GetAssignment(hit = hit)[[1]][1] -> assignment

  # Feedback that's too long (more than 1024 characters)
  expect_type(ApproveAssignment(assignments = assignment,
                                verbose = FALSE,
                                feedback = paste(sample(LETTERS, 1025, replace=TRUE), collapse="")), "list")
})


test_that("ApproveAllAssignments with annotation", {
  skip_if_not(CheckAWSKeys())
  expect_type(ApproveAllAssignments(annotation = 'BatchId:248805'), "list")
})


test_that("ApproveAllAssignments when Assignments are not found", {
  skip_if_not(CheckAWSKeys())
  expect_s3_class(try(ApproveAllAssignments(annotation = '!@$##$@##$'), TRUE), "try-error")
})

