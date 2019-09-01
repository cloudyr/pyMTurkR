
test_that("GetReviewResultsForHIT", {
  skip_if_not(CheckAWSKeys())

  # Fetch hits
  SearchHITs() -> hits

  # GetReviewResultsForHIT using HITId
  GetReviewResultsForHIT(hit = as.factor(hits$HITs$HITId[[1]])) -> result
  expect_type(result, "list")

  # GetReviewResultsForHIT using HITId, specifying a policy level
  GetReviewResultsForHIT(hit = as.factor(hits$HITs$HITId[[1]]),
                         policy.level = 'HIT') -> result
  expect_type(result, "list")

})
