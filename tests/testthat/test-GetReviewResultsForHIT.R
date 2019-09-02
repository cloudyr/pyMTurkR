
test_that("GetReviewResultsForHIT", {
  skip_if_not(CheckAWSKeys())

  # Fetch hits
  GetAssignment(hit.type = '3ZY5FK1Q9GOM4W6XMFN2W6BL58VO8Z',
                results = 1)$HITId -> hit

  # GetReviewResultsForHIT using HITId
  GetReviewResultsForHIT(hit = as.factor(hit)) -> result
  expect_type(result, "list")

  # GetReviewResultsForHIT using HITId, specifying a policy level
  GetReviewResultsForHIT(hit = as.factor(hit),
                         policy.level = 'HIT') -> result
  expect_type(result, "list")

  # GetReviewResultsForHIT for a HIT that actually has policies
  GetReviewResultsForHIT('3NZ1E5QA6Z108TQ3QK6XTM947PJB5B') -> result
  expect_type(result, "list")

})
