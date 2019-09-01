
test_that("GetReviewableHITs", {
  skip_if_not(CheckAWSKeys())
  skip_if(nrow(try(GetAssignment(hit.type = '3ZY5FK1Q9GOM4W6XMFN2W6BL58VO8Z',
                                 results = 1,
                                 status = 'Submitted'), TRUE)) == 0)

  # GetReviewableHITs using HITTypeId
  GetReviewableHITs(hit.type = '3ZY5FK1Q9GOM4W6XMFN2W6BL58VO8Z') -> result
  expect_type(result, "list")

  # GetReviewableHITs using HITTypeId, 1 result
  GetReviewableHITs(hit.type = '3ZY5FK1Q9GOM4W6XMFN2W6BL58VO8Z',
                    results = 1) -> result
  expect_type(result, "list")

  # GetReviewableHITs using HITTypeId, 2 results
  GetReviewableHITs(hit.type = '3ZY5FK1Q9GOM4W6XMFN2W6BL58VO8Z',
                    results = 2) -> result
  expect_type(result, "list")

})
