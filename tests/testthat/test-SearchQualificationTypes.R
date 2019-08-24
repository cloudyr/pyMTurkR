
test_that("SearchQuals", {
  skip_if_not(CheckAWSKeys())
  expect_type(SearchQuals(verbose = FALSE), "list")
  expect_type(SearchQuals(verbose = TRUE), "list")
})

test_that("SearchQuals search query", {
  skip_if_not(CheckAWSKeys())
  expect_type(SearchQuals(verbose = FALSE,
                          search.query = 'cats',
                          results = 1), "list")
})

test_that("SearchQuals two results", {
  skip_if_not(CheckAWSKeys())
  SearchQuals(verbose = FALSE,
              must.be.owner = TRUE,
              results = 1,
              return.pages = 2) -> result
  expect_type(result, "list")
  expect_length(result$QualificationTypeId, 2)
})
