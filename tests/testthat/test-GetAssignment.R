
test_that("GetAssignment", {
  skip_if_not(CheckAWSKeys())
  skip_if(nrow(try(GetAssignment(hit.type = '3ZY5FK1Q9GOM4W6XMFN2W6BL58VO8Z',
                                 results = 1), TRUE)) == 0)
  # Fetch hits
  SearchHITs() -> hits

  # GetAssignment using HITId
  GetAssignment(hit = as.factor(hits$HITs$HITId[[1]])) -> result
  expect_type(result, "list")

  # GetAssignment using HITTypeId
  GetAssignment(hit.type = as.factor('3ZY5FK1Q9GOM4W6XMFN2W6BL58VO8Z')) -> result
  expect_type(result, "list")

  # GetAssignment using Annotation
  tail(hits$HITs$RequesterAnnotation[!is.na(hits$HITs$RequesterAnnotation)], 1) -> annot
  GetAssignment(annotation = as.factor(annot)) -> result
  expect_type(result, "list")

  # GetAssignment using HITTypeId, specifying a status
  GetAssignment(hit.type = '3ZY5FK1Q9GOM4W6XMFN2W6BL58VO8Z',
                status = 'Submitted') -> result
  expect_type(result, "list")

  # GetAssignment using Assignment
  GetAssignment(hit.type = '3ZY5FK1Q9GOM4W6XMFN2W6BL58VO8Z') -> result
  GetAssignment(assignment = result$AssignmentId) -> result
  expect_type(result, "list")

  # GetAssignment using HITTypeId, specifying number of results
  GetAssignment(hit.type = '3ZY5FK1Q9GOM4W6XMFN2W6BL58VO8Z',
                results = 1) -> result
  expect_type(result, "list")

  # GetAssignment using Annotation, return answers
  GetAssignment(annotation = annot,
                get.answers = TRUE,
                results = 1) -> result
  expect_type(result, "list")

  # GetAssignment using HITTypeId, return answers
  GetAssignment(hit.type = '3ZY5FK1Q9GOM4W6XMFN2W6BL58VO8Z',
                get.answers = TRUE,
                results = 1) -> result
  expect_type(result, "list")

})
