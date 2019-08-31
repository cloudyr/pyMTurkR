test_that("GetQualificationRequests", {
  skip_if_not(CheckAWSKeys())

  # GetQualificationRequests, nothing specified
  GetQualificationRequests() -> result
  expect_type(result, "list")

  # GetQualificationRequests qual specified
  SearchQualificationTypes(must.be.owner = TRUE, verbose = FALSE) -> quals
  quals$QualificationTypeId[[1]] -> qual1
  GetQualificationRequests(qual = as.factor(qual1)) -> result
  expect_type(result, "list")

})

test_that("GetQualificationRequests error don't own qual", {
  skip_if_not(CheckAWSKeys())

  try(GetQualificationRequests("2YCIA0RYNJ9262B1D82MPTUEXAMPLE")) -> result
  expect_s3_class(result, 'try-error')
})
