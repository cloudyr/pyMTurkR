test_that("GrantQualification", {
  skip_if_not(CheckAWSKeys())

  GetQualificationRequests() -> requests
  GrantQualification(requests$QualificationRequestId[[1]], 1) -> result
  expect_type(result, "list")
  RevokeQualification(requests$QualificationTypeId[[1]], workers = requests$WorkerId[[1]])

})
