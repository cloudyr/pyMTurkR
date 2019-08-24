
test_that("GetClient", {
  skip_if_not(CheckAWSKeys())
  expect_type(GetClient(), "environment")
})

test_that("CheckAWSKeys", {
  expect_type(CheckAWSKeys(), "logical")
})
