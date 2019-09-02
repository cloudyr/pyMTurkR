test_that("multiplication works", {
  skip_if_not(CheckAWSKeys())

  hittype <- RegisterHITType(title="10 Question Survey",
                             description = "Complete a 10-question survey",
                             reward = ".20",
                             duration = seconds(hours = 1),
                             keywords = "survey, questionnaire, politics")

  a <- GenerateNotification("requester@example.com", event.type = "HITExpired")

  SetHITTypeNotification(hit.type = hittype$HITTypeId,
                         notification = a,
                         active = TRUE) -> result1

  SetHITTypeNotification(hit.type = hittype$HITTypeId,
                         notification = a,
                         active = FALSE) -> result2

  SetHITTypeNotification(hit.type = hittype$HITTypeId,
                         active = TRUE) -> result3

  SetHITTypeNotification(hit.type = hittype$HITTypeId,
                         active = FALSE) -> result4

  expect_type(result1, "list")
  expect_type(result2, "list")
  expect_type(result3, "list")
  expect_type(result4, "list")

})
