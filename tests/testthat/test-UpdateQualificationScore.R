test_that("UpdateQualificationScore", {
  skip_if_not(CheckAWSKeys())

  SearchQualificationTypes(must.be.owner = TRUE, verbose = FALSE) -> quals
  quals$QualificationTypeId[[1]] -> qual1
  AssignQualification(workers = "A3LXJ76P1ZZPMC", qual = qual1)

  # Increment by 1
  UpdateQualificationScore(workers = "A3LXJ76P1ZZPMC",
                           qual = qual1,
                           increment = TRUE) -> result
  expect_type(result, "list")

  # Increment by 3
  UpdateQualificationScore(workers = "A3LXJ76P1ZZPMC",
                           qual = qual1,
                           increment = "3") -> result
  expect_type(result, "list")

  # Set value to 1
  UpdateQualificationScore(workers = "A3LXJ76P1ZZPMC",
                           qual = qual1,
                           value = 1) -> result
  expect_type(result, "list")

  # Cleanup
  RevokeQualification(qual1, "A3LXJ76P1ZZPMC")

})
