
test_that("Change HIT type", {
  skip_if_not(CheckAWSKeys())

  # Register a HIT type
  hittype1 <- RegisterHITType(title = "10 Question Survey",
                              description = "Complete a 10-question survey about news coverage and your opinions",
                              reward = ".20",
                              duration = seconds(hours=1),
                              keywords = "survey, questionnaire, politics")

  # Create a HIT using the HIT type just created
  a <- GenerateExternalQuestion("https://www.example.com", "400")
  hit <- CreateHIT(hit.type = hittype1$HITTypeId,
                   assignments = 1,
                   expiration = seconds(days=1),
                   question = a$string)

  # Create a second HIT type
  hittype2 <- RegisterHITType(title = "10 Question Survey",
                    description = "Complete a 10-question survey about news coverage and your opinions",
                    reward = ".45",
                    duration = seconds(hours=1),
                    keywords = "survey, questionnaire, politics")

  # Wait 15s to give the HIT time to "be made available in the marketplace"
  Sys.sleep(15)

  # Now change the HIT type of the HIT created previously
  expect_type(ChangeHITType(hit = hit$HITId, new.hit.type = hittype2$HITTypeId), "list")

  # as.factor
  expect_type(ChangeHITType(hit = as.factor(hit$HITId), new.hit.type = hittype2$HITTypeId), "list")

  # Title ignored
  expect_type(ChangeHITType(hit = as.factor(hit$HITId), new.hit.type = hittype2$HITTypeId, title = 'x'), "list")

  # Delete HIT
  DeleteHIT(hit$HITId,
            delete.hit = TRUE,
            approve.pending.assignments = TRUE,
            verbose = FALSE)
})



test_that("Change HIT type", {
  skip_if_not(CheckAWSKeys())

  # Register a HIT type
  hittype1 <- RegisterHITType(title = "10 Question Survey",
                              description = "Complete a 10-question survey about news coverage and your opinions",
                              reward = ".20",
                              duration = seconds(hours=1),
                              keywords = "survey, questionnaire, politics")

  # Create a HIT using the HIT type just created
  a <- GenerateExternalQuestion("https://www.example.com", "400")
  hit <- CreateHIT(hit.type = hittype1$HITTypeId,
                   assignments = 1,
                   expiration = seconds(days=1),
                   question = a$string)

  # Define new HIT type in function call
  expect_type(ChangeHITType(hit = as.factor(hit$HITId), new.hit.type = hittype2$HITTypeId, title = 'x'), "list")


})
