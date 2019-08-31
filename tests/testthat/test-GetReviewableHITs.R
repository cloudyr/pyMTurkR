
test_that("GetReviewableHITs", {
  skip_if_not(CheckAWSKeys())

  # Fetch hits
  SearchHITs() -> hits

  # GetReviewableHITs using HITTypeId
  GetReviewableHITs(hit.type = as.factor(hits$HITs$HITTypeId[[1]])) -> result
  expect_type(result, "list")

  # GetReviewableHITs using HITTypeId, 1 result
  GetReviewableHITs(hit.type = as.factor(hits$HITs$HITTypeId[[1]]),
                    results = 1) -> result
  expect_type(result, "list")

  # GetReviewableHITs using HITTypeId, 2 results
  GetReviewableHITs(hit.type = as.factor(hits$HITs$HITTypeId[[1]]),
                    results = 2) -> result
  expect_type(result, "list")

})
