test_that("SetHITTypeNotification", {
  skip_if_not(CheckAWSKeys())

  hittype <- RegisterHITType(title="10 Question Survey",
                    description = "Complete a 10-question survey",
                    reward = ".20",
                    duration = seconds(hours = 1),
                    keywords = "survey, questionnaire, politics")

  a <- GenerateNotification("requester@example.com", event.type = "HITExpired")
  SetHITTypeNotification(hit.type = hittype$HITTypeId,
                         notification = a,
                         active = TRUE)

  # send test notification
  SendTestEventNotification(a, test.event.type = "HITExpired") -> result
  expect_type(result, "list")

  # Invalid type
  try(SendTestEventNotification(a, test.event.type = "X"), TRUE) -> result

})
