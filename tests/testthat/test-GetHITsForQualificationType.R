test_that("GetHITsForQualificationType", {
  skip_if_not(CheckAWSKeys())

  # Fetch hits
  SearchHITs() -> hits

  # GetHITsForQualificationType
  qual <- hits$QualificationRequirements$QualificationTypeId[[1]]
  GetHITsForQualificationType(qual = as.factor(qual)) -> result
  expect_type(result, "list")

  # GetHITsForQualificationType
  GetHITsForQualificationType(qual = as.factor(qual), results = 1) -> result
  expect_type(result, "list")
})
