
test_that("ApproveAllAssignments with more than one feedback", {
  skip_if_not(CheckAWSKeys())
  expect_s3_class(try(ApproveAllAssignments(hit = 'NOTAHIT',
                                            feedback = c("1", "2")), TRUE), "try-error")
})


test_that("ApproveAllAssignments with missing parameters", {
  skip_if_not(CheckAWSKeys())
  expect_s3_class(try(ApproveAllAssignments(), TRUE), "try-error")
})


test_that("ApproveAllAssignments with hit.type", {
  skip_if_not(CheckAWSKeys())
  skip_if(nrow(try(GetAssignment(hit.type = '3ZY5FK1Q9GOM4W6XMFN2W6BL58VO8Z',
                                 results = 1), TRUE)) == 0)

  # Get HITs then HIT Type
  GetAssignment(hit.type = '3ZY5FK1Q9GOM4W6XMFN2W6BL58VO8Z',
                results = 1)$HITId -> hit

  GetHIT(hit) -> hit
  hit$HITs$HITTypeId[[1]] -> hit.type
  expect_type(ApproveAllAssignments(hit.type = hit.type, verbose = FALSE), "list")

})


test_that("ApproveAllAssignments with hit", {
  skip_if_not(CheckAWSKeys())
  skip_if(nrow(try(GetAssignment(hit.type = '3ZY5FK1Q9GOM4W6XMFN2W6BL58VO8Z',
                                      results = 1), TRUE)) == 0)

  # Get HITs then HIT Type
  GetAssignment(hit.type = '3ZY5FK1Q9GOM4W6XMFN2W6BL58VO8Z',
                results = 1)$HITId -> hit

  expect_type(ApproveAllAssignments(hit = hit), "list")

})


test_that("ApproveAllAssignments with feedback that's too long", {
  skip_if_not(CheckAWSKeys())
  skip_if(nrow(try(GetAssignment(hit.type = '3ZY5FK1Q9GOM4W6XMFN2W6BL58VO8Z',
                                 results = 1), TRUE)) == 0)

  # Get HITs then Assignment
  GetAssignment(hit.type = '3ZY5FK1Q9GOM4W6XMFN2W6BL58VO8Z',
                results = 1)$AssignmentId -> assignment

  # Feedback that's too long (more than 1024 characters)
  expect_s3_class(try(ApproveAssignment(assignments = assignment,
                                verbose = FALSE,
                                feedback = paste(sample(LETTERS, 1025, replace=TRUE), collapse="")), TRUE), "try-error")
})


test_that("ApproveAllAssignments with annotation", {
  skip_if_not(CheckAWSKeys())
  skip_if(nrow(try(GetAssignment(hit.type = '3ZY5FK1Q9GOM4W6XMFN2W6BL58VO8Z',
                                 results = 1), TRUE)) == 0)

  # Get HITs then Assignment
  GetAssignment(hit.type = '3ZY5FK1Q9GOM4W6XMFN2W6BL58VO8Z',
                results = 1,
                status = 'Submitted')$HITId -> hit

  GetHIT(hit) -> hit
  hits$HITs$RequesterAnnotation[[1]] -> annotation

  expect_type(ApproveAllAssignments(annotation = annotation), "list")

})


test_that("ApproveAllAssignments when Assignments are not found", {
  skip_if_not(CheckAWSKeys())
  expect_s3_class(try(ApproveAllAssignments(annotation = '!@$##$@##$'), TRUE), "try-error")
})

