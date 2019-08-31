test_that("GetQualificationType", {
  skip_if_not(CheckAWSKeys())

  SearchQualificationTypes(must.be.owner = TRUE, verbose = FALSE) -> quals
  quals$QualificationTypeId[[1]] -> qual1
  GetQualificationType(as.factor(qual1)) -> result
  expect_type(result, "list")

})
