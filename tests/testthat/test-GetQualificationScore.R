test_that("GetQualificationScore", {
  skip_if_not(CheckAWSKeys())

  SearchQualificationTypes(must.be.owner = TRUE, verbose = FALSE) -> quals
  quals$QualificationTypeId[[1]] -> qual1
  AssignQualification(workers = "A3LXJ76P1ZZPMC", qual = qual1)
  GetQualificationScore(as.factor(qual1), as.factor("A3LXJ76P1ZZPMC")) -> result
  expect_type(result, "list")

  # One qual, multiple workers
  GetQualificationScore(qual1, c("A3LXJ76P1ZZPMC","A3LXJ76P1ZZPMC")) -> result
  expect_type(result, "list")

  # Error -- Qual list must = 1 or length(workers)
  try(GetQualificationScore(c(qual1,qual1), "A3LXJ76P1ZZPMC")) -> result
  expect_s3_class(result, 'try-error')

  RevokeQualification(qual1, "A3LXJ76P1ZZPMC")

})
