listb <- list(QuestionIds = c("Question1","Question2","Question5"),
              QuestionAgreementThreshold = 65, # at least two of three 'correct' answers
              ApproveIfWorkerAgreementScoreIsAtLeast = 65,
              RejectIfWorkerAgreementScoreIsLessThan = 34,
              DisregardAssignmentIfRejected = TRUE)
policyb <- do.call(GenerateHITReviewPolicy, listb)

hit1 <-
  CreateHIT(title = "Survey",
            description = "5 question survey",
            reward = "0.10",
            expiration = seconds(days = 4),
            duration = seconds(hours = 1),
            assignments = 1,
            question = GenerateHTMLQuestion(file = "inst/templates/htmlquestion3.xml"),
            assignment.review.policy = policyb)



request <- paste0('"', dict(policyb), '"')
eval(parse(text = request))
