test_that("GetQualifications", {
  skip_if_not(CheckAWSKeys())

  SearchQualificationTypes(must.be.owner = TRUE, verbose = FALSE) -> quals
  quals$QualificationTypeId[[1]] -> qual1
  AssignQualification(workers = "A3LXJ76P1ZZPMC", qual = qual1)
  GetQualifications(qual1) -> result
  expect_type(result, "list")

  RevokeQualification(qual1, "A3LXJ76P1ZZPMC")
  GetQualifications(qual1, status = "Revoked")
  expect_type(result, "list")

})
