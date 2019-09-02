
test_that("GetBonuses", {
  skip_if_not(CheckAWSKeys())

  # Fetch hits
  SearchHITs() -> hits

  # GetBonuses using HITId
  GetBonuses(hit = as.factor(hits$HITs$HITId[[1]])) -> result
  expect_type(result, "list")

  # GetBonuses using HITTypeId
  GetBonuses(hit.type = as.factor('3ZY5FK1Q9GOM4W6XMFN2W6BL58VO8Z')) -> result
  expect_type(result, "list")

  # GetBonuses using Annotation
  annot <- hits$HITs$RequesterAnnotation[!is.na(hits$HITs$RequesterAnnotation)][[1]]
  GetBonuses(annotation = as.factor(annot)) -> result
  expect_type(result, "list")

  # GetBonuses using HITTypeId, specifying number of pages, results
  GetBonuses(hit.type = hits$HITs$HITTypeId[[1]],
                results = 1) -> result
  expect_type(result, "list")


})
