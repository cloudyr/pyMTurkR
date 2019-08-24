
test_that("SearchQuals", {
  skip_if_not(CheckAWSKeys())
  expect_type(SearchQuals(verbose = FALSE), "list")
})

test_that("SearchQuals two results", {
  skip_if_not(CheckAWSKeys())
  SearchQuals(verbose = FALSE,
              must.be.owner = TRUE,
              results = 1,
              return.pages = 2) -> result
  expect_type(result, "list")
  expect_length(result, 2)
})
