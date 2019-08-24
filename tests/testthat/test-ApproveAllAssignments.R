
test_that("ApproveAllAssignments with incorrect HIT specification", {
  skip_if_not(CheckAWSKeys())
  expect_type(ApproveAllAssignments(hit = 'NOTAHIT', verbose = FALSE), "list")
  expect_type(ApproveAllAssignments(hit = 'NOTAHIT', verbose = TRUE), "list")
  expect_type(ApproveAllAssignments(hit = as.factor('NOTAHIT'), verbose = FALSE), "list")
})


test_that("ApproveAllAssignments with more than one feedback", {
  skip_if_not(CheckAWSKeys())
  expect_type(class(try(ApproveAllAssignments(hit = 'NOTAHIT', feedback = c("1", "2")))), "try-error")
})


test_that("ApproveAllAssignments with more than one feedback", {
  skip_if_not(CheckAWSKeys())

  # Get HITs then HIT Type
  SearchHITs() -> hits
  hits$HITs$HITTypeId[[1]] -> hit.type

  expect_type(ApproveAllAssignments(hit.type = hit.type, feedback = "good job"), "list")
})
