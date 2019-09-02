test_that("multiplication works", {
  skip_if_not(CheckAWSKeys())

  SearchHITs() -> hits
  hits$HITs$HITId[hits$HITs$HITStatus == 'Reviewable'][[1]] -> hit
  SetHITAsReviewing(hit) -> result1
  SetHITAsReviewing(hit, revert = TRUE) -> result2

  expect_type(result1, "list")
  expect_type(result2, "list")

})
