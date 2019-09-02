test_that("RejectQualification", {
  skip_if_not(CheckAWSKeys())
  skip_if(nrow(try(GetQualificationRequests(), TRUE)) == 0)

  GetQualificationRequests() -> requests
  RejectQualification(qual.requests = requests$QualificationRequestId[[1]],
                      reason = 'Not qualified', verbose = FALSE) -> result
  expect_type(result, "list")

})
