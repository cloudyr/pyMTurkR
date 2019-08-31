
test_that("GetAssignment", {
  skip_if_not(CheckAWSKeys())

  # Fetch hits
  SearchHITs() -> hits

  # GetAssignment using HITId
  GetAssignment(hit = as.factor(hits$HITs$HITId[[1]])) -> result
  expect_type(result, "list")

  # GetAssignment using HITTypeId
  GetAssignment(hit.type = as.factor(hits$HITs$HITTypeId[[1]])) -> result
  expect_type(result, "list")

  # GetAssignment using Annotation
  annot <- hits$HITs$RequesterAnnotation[!is.na(hits$HITs$RequesterAnnotation)][[1]]
  GetAssignment(annotation = as.factor(annot)) -> result
  expect_type(result, "list")

  # GetAssignment using HITTypeId, specifying a status
  GetAssignment(hit.type = hits$HITs$HITTypeId[[1]],
                status = 'Submitted') -> result
  expect_type(result, "list")

  # GetAssignment using Assignment
  GetAssignment(annotation = ';') -> result
  GetAssignment(assignment = result$AssignmentId) -> result
  expect_type(result, "list")

  # GetAssignment using HITTypeId, specifying number of pages, results
  GetAssignment(hit.type = hits$HITs$HITTypeId[[1]],
                results = 1) -> result
  expect_type(result, "list")

  # GetAssignment using Annotation, return answers
  GetAssignment(annotation = ';',
                get.answers = TRUE) -> result
  expect_type(result, "list")


})
