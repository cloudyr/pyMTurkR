test_that("GrantQualification", {
  skip_if_not(CheckAWSKeys())
  skip_if(nrow(try(GetQualificationRequests(), TRUE)) == 0)

  GetQualificationRequests() -> requests
  GrantQualification(requests$QualificationRequestId[[1]], 1) -> result
  expect_type(result, "list")
  RevokeQualification(requests$QualificationTypeId[[1]], workers = requests$WorkerId[[1]])

})
