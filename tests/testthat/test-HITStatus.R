
test_that("HITStatus", {
  skip_if_not(CheckAWSKeys())

  # No parameters
  HITStatus() -> result
  expect_type(result, "list")

  # Fetch hits
  SearchHITs() -> hits

  # HITStatus using HITId
  HITStatus(hit = as.factor(hits$HITs$HITId[[1]])) -> result
  expect_type(result, "list")

  # HITStatus using HITTypeId
  HITStatus(hit = as.factor(hits$HITs$HITTypeId[[1]])) -> result
  expect_type(result, "list")

})
