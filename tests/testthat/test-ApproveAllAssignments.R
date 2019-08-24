
test_that("ApproveAllAssignments with more than one feedback", {
  skip_if_not(CheckAWSKeys())
  expect_type(class(try(ApproveAllAssignments(hit = 'NOTAHIT', feedback = c("1", "2")))), "try-error")
})


test_that("ApproveAllAssignments with missing parameters", {
  skip_if_not(CheckAWSKeys())
  expect_type(class(try(ApproveAllAssignments())), "try-error")
})


test_that("ApproveAllAssignments with hit.type", {
  skip_if_not(CheckAWSKeys())

  # Get HITs then HIT Type
  SearchHITs() -> hits
  hits$HITs$HITTypeId[[1]] -> hit.type

  expect_type(ApproveAllAssignments(hit.type = hit.type), "list")
})


test_that("ApproveAllAssignments with hit", {
  skip_if_not(CheckAWSKeys())

  # Get HITs then HIT Type
  SearchHITs() -> hits
  hits$HITs$HITId[[1]] -> hit

  expect_type(ApproveAllAssignments(hit = hit), "list")
})


test_that("ApproveAllAssignments with feedback that's too long", {
  # Feedback that's too long (more than 1024 characters)
  expect_type(ApproveAssignment(assignments = assignment$AssignmentId,
                                verbose = FALSE,
                                feedback = paste(sample(LETTERS, 1025, replace=TRUE), collapse="")), "list")
})


test_that("ApproveAllAssignments with annotation", {
  skip_if_not(CheckAWSKeys())
  expect_type(ApproveAllAssignments(annotation = 'BatchId:248805'), "list")
})


test_that("ApproveAllAssignments when Assignments are not found", {
  skip_if_not(CheckAWSKeys())
  expect_type(class(try(ApproveAllAssignments(annotation = '!@$##$@##$'))), "try-error")
})

