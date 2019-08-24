
test_that("AccountBalance", {
  skip_if_not(CheckAWSKeys())
  expect_type(AccountBalance(), "character")
})
