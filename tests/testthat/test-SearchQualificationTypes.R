
test_that("SearchQuals", {
  skip_if_not(CheckAWSKeys())
  expect_type(SearchQuals(verbose = FALSE), "list")
})
