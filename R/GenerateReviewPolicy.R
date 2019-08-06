#' REVIEW POLICIES NOT SUPPORTED
#'
#' Generate HIT and/or Assignment ReviewPolicies
#'
#' Generate a HIT ReviewPolicy and/or Assignment ReviewPolicy data structure
#' for use in \code{\link{CreateHIT}}.
#'
#' Converts a list of ReviewPolicy parameters into a ReviewPolicy data
#' structure.
#'
#' A ReviewPolicy works by testing whether an assignment or a set of
#' assignments satisfies a particular condition. If that condition is
#' satisfied, then specified actions are taken. ReviewPolicies come in two
#' \dQuote{flavors}: Assignment-level ReviewPolicies take actions based on
#' \dQuote{known} answers to questions in the HIT and HIT-level ReviewPolicies
#' take actions based on agreement among multiple assignments. It is possible
#' to specify both Assignment-level and HIT-level ReviewPolicies for the same
#' HIT.
#'
#' Assignment-level ReviewPolicies involve checking whether that assignment
#' includes particular (\dQuote{correct}) answers. For example, an assignment
#' might be tested to see whether a correct answer is given to one question by
#' each worker as a quality control measure. The ReviewPolicy works by checking
#' whether a specified percentage of known answers are correct. So, if a
#' ReviewPolicy specifies two known answers for a HIT and the worker gets one
#' of those known answers correct, the ReviewPolicy scores the assignment at 50
#' (i.e., 50 percent). The ReviewPolicy can then be customized to take three
#' kinds of actions depending on that score:
#' \code{ApproveIfKnownAnswerScoreIsAtLeast} (approve the assignment
#' automatically), \code{RejectIfKnownAnswerScoreIsLessThan} (reject the
#' assignment automatically), and \code{ExtendIfKnownAnswerScoreIsLessThan}
#' (add additional assignments and/or time to the HIT automatically). The
#' various actions can be combined to, e.g., both reject an assignment and add
#' further assignments if a score is below the threshold, or reject below a
#' threshold and approve above, etc.
#'
#' HIT-level ReviewPolicies involve checking whether multiple assignments
#' submitted for the same HIT \dQuote{agree} with one another. Agreement here
#' is very strict: answers must be exactly the same across assignments for them
#' to be a matched. As such, it is probably only appropriate to use
#' closed-ended (e.g., multiple choice) questions for HIT-level ReviewPolicies
#' otherwise ReviewPolicy actions might be taken on irrelevant differences
#' (e.g., word capitalization, spacing, etc.). The ReviewPolicy works by
#' checking whether answers to multiple assignments are the same (or at least
#' whether a specified percentage of answers to a given question are the same).
#' For example, if the goal is to categorize an image into one of three
#' categories, the ReviewPolicy will check whether two of three workers agree
#' on the categorization (known as the \dQuote{HIT Agreement Score}, which is a
#' percentage of all workers who agree). Depending on the value of the HIT
#' Agreement Score, actions can be taken. As of October 2014, only one action
#' can be taken: \code{ExtendIfHITAgreementScoreIsLessThan} (extending the HIT
#' in assignments by the number of assignments specified in
#' \code{ExtendMaximumAssignments} or time as specified in
#' \code{ExtendMinimumTimeInSeconds}).
#'
#' Another agreement score (the \dQuote{Worker Agreement Score}), measured the
#' percentage of a worker's responses that agree with other workers' answers.
#' Depending on the Worker Agreement Score, two actions can be taken:
#' \code{ApproveIfWorkerAgreementScoreIsAtLeast} (to approve the assignment
#' automatically) or \code{RejectIfWorkerAgreementScoreIsLessThan} (to reject
#' the assignment automatically, with an optional reject reason supplied with
#' \code{RejectReason}). A logical value (\code{DisregardAssignmentIfRejected})
#' specifies whether to exclude rejected assignments from the calculation of
#' the HIT Agreement Score.
#'
#' Note: An optional \code{DisregardAssignmentIfKnownAnswerScoreIsLessThan}
#' excludes assignments if those assignments score below a specified
#' \dQuote{known} answers threshold as determined by a separate
#' Assignment-level ReviewPolicy.
#'
#' @aliases GenerateHITReviewPolicy GenerateAssignmentReviewPolicy
#' @param ... ReviewPolicy parameters passed as named arguments.
#' @return A dictionary object
#' \code{HITReviewPolicy} or \code{AssignmentReviewPolicy}.
#' @author Tyler Burleigh, Thomas J. Leeper
#' @references
#' \href{http://docs.amazonwebservices.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_QuestionFormDataStructureArticle.html}{API Reference: QuestionForm}
#'
#' \href{http://docs.amazonwebservices.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_ReviewPoliciesArticle.html}{API Reference (ReviewPolicies)}
#'
#' \href{http://docs.amazonwebservices.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_HITReviewPolicyDataStructureArticle.html}{APIReference (Data Structure)}
#' @keywords HITs
#'
#' \dontrun{
#'
#'
#' # Generate a HIT Review Policy with GenerateHITReviewPolicy
#'
#' lista <- list(QuestionIds = c("Question1", "Question2"),
#'               QuestionAgreementThreshold = 75,
#'               ApproveIfWorkerAgreementScoreIsAtLeast = 75,
#'               RejectIfWorkerAgreementScoreIsLessThan = 25)
#' policya <- do.call(GenerateHITReviewPolicy, lista)
#'
#'
#' # Manually define a HIT Review Policy
#'
#' policya <- dict(
#'			list(
#'				'PolicyName' = 'SimplePlurality/2011-09-01',
#'				'Parameters' = list(
#'				  dict(
#'					  'Key' = 'QuestionIds',
#'					  'Values' = list(
#'					    'Question1',
#'					    'Question2'
#'				  	)
#'				  ),
#'				  dict(
#'				  	'Key' = 'QuestionAgreementThreshold',
#'				  	'Values' = list(
#'				  	  '75'
#'				  	)
#'				  ),
#'				  dict(
#'				  	'Key' = 'ApproveIfWorkerAgreementScoreIsAtLeast',
#'				  	'Values' = list(
#'				  	  '75'
#'				  	)
#'				  ),
#'				  dict(
#'				  	'Key' = 'RejectIfWorkerAgreementScoreIsLessThan',
#'				  	'Values' = list(
#'				  	  '25'
#'				  	)
#'				  )
#'				)
#'			))
#'
#'
#'
#' # Generate an Assignment Review Policy with GenerateAssignmentReviewPolicy
#'
#' listb <- list(AnswerKey = list("QuestionId1" = "B", "QuestionId2" = "A"),
#'               ApproveIfKnownAnswerScoreIsAtLeast = 99)
#' policyb <- do.call(GenerateAssignmentReviewPolicy, listb)
#'
#'
#' # Manually define an Assignment Review Policy
#'
#' policyb <- dict(
#'			list(
#'				'PolicyName' = 'ScoreMyKnownAnswers/2011-09-01',
#'				'Parameters' = list(
#'				  dict(
#'					  'Key' = 'AnswerKey',
#'					  'MapEntries' = list(
#'						dict(
#'							'Key' = 'QuestionId1',
#'							'Values' = list('B')
#'						),
#'						dict(
#'							'Key' = 'QuestionId2',
#'							'Values' = list('A')
#'						)
#'				  	)
#'				  ),
#'				  dict(
#'				  	'Key' = 'ApproveIfKnownAnswerScoreIsAtLeast',
#'				  	'Values' = list(
#'				  	  '99'
#'				  	)
#'				  )
#'				)
#'			))
#'
#'}

GenerateHITReviewPolicy <-
  function(...) {

    l <- list(...)
    h <- list("PolicyName" = "SimplePlurality/2011-09-01",
              "Parameters" = list())

    if (("ExtendIfHITAgreementScoreIsLessThan" %in% names(l)) &&
        ((!"ExtendMaximumAssignments" %in% names(l)) |
         (!"ExtendMinimumTimeInSeconds" %in% names(l)) ) ) {
      stop(paste0("ExtendMaximumAssignments and ExtendMinimumTimeInSeconds required",
                  " if using ExtendIfHITAgreementScoreIsLessThan"))
    }
    if("ExtendIfHITAgreementScoreIsLessThan" %in% names(l) &&
       (as.numeric(l$ExtendIfHITAgreementScoreIsLessThan) > 100 |
        as.numeric(l$ExtendIfHITAgreementScoreIsLessThan) < 1)) {
      stop("ExtendIfHITAgreementScoreIsLessThan must be between 0 and 100")
    }
    if ("ExtendMinimumTimeInSeconds" %in% names(l) &&
        (as.numeric(l$ExtendMinimumTimeInSeconds) > 31536000 |
         as.numeric(l$ExtendMinimumTimeInSeconds) < 3600)) {
      stop("ExtendMinimumTimeInSeconds must be between one hour and one year")
    }
    if ("DisregardAssignmentIfRejected" %in% names(l) &&
        (!as.character(l$DisregardAssignmentIfRejected) %in% c("TRUE","FALSE"))) {
      stop("DisregardAssignmentIfRejected must be TRUE or FALSE")
    }
    if(!exists("QuestionIds", l)){
      stop("QuestionIds is missing")
    }
    if (length(l$QuestionIds) > 15) {
      stop("Max number of 'QuestionIds' is 15")
    }

    # Build QuestionIds list
    h$Parameters[[1]] <- list("Key" = "QuestionIds", "Values" = list())
    for (i in 1:length(l$QuestionIds)) {
      h$Parameters[[1]]$Values[[length(h$Parameters[[1]]$Values) + 1]] <- as.character(l$QuestionIds[i])
    }

    l$QuestionIds <- NULL

    if(length(l) == 0){
      stop("Missing other parameters")
    }

    # Check other parameters
    for (i in 1:length(l)) {
      # Check that parameters are allowed
      if (!names(l)[i] %in% c("QuestionAgreementThreshold",
                              "DisregardAssignmentIfRejected", "DisregardAssignmentIfKnownAnswerScoreIsLessThan",
                              "ExtendIfHITAgreementScoreIsLessThan", "ExtendMaximumAssignments",
                              "ExtendMinimumTimeInSeconds", "ApproveIfWorkerAgreementScoreIsAtLeast",
                              "RejectIfWorkerAgreementScoreIsLessThan", "RejectReason")) {
        stop(paste0("Inappropriate HIT ReviewPolicy Parameter: ",names(l)[i]))
      }

      key <- names(l)[i]
      values <- l[[i]]
      h$Parameters[[i+1]] <- list("Key" = key, "Values" = list(as.character(values)))
    }

    # Convert to dictionary objects
    for (i in 1:length(h$Parameters)) {
      h$Parameters[[i]] <- reticulate::dict(h$Parameters[[i]])
    }

    h <- reticulate::dict(h)
    return(h)
  }





GenerateAssignmentReviewPolicy <-
  function(...) {

    l <- list(...)
    a <- list("PolicyName" = "ScoreMyKnownAnswers/2011-09-01",
              "Parameters" = list())

    if ("ApproveIfKnownAnswerScoreIsAtLeast" %in% names(l) &&
        (as.numeric(l$ApproveIfKnownAnswerScoreIsAtLeast) > 101 |
         as.numeric(l$ApproveIfKnownAnswerScoreIsAtLeast) < 1)) {
      stop("ApproveIfKnownAnswerScoreIsAtLeast must be between 0 and 101")
    }
    if ("RejectIfKnownAnswerScoreIsLessThan" %in% names(l) &&
        (as.numeric(l$RejectIfKnownAnswerScoreIsLessThan) > 101 |
         as.numeric(l$RejectIfKnownAnswerScoreIsLessThan) < 1)) {
      stop("RejectIfKnownAnswerScoreIsLessThan must be between 0 and 101")
    }
    if ("ExtendIfKnownAnswerScoreIsLessThan" %in% names(l) &&
        (as.numeric(l$ExtendIfKnownAnswerScoreIsLessThan) > 101 |
         as.numeric(l$ExtendIfKnownAnswerScoreIsLessThan) < 1)) {
      stop("ExtendIfKnownAnswerScoreIsLessThan must be between 0 and 101")
    }
    if ("ExtendMaximumAssignments" %in% names(l) &&
        (as.numeric(l$ExtendMaximumAssignments) > 25 |
         as.numeric(l$ExtendMaximumAssignments) < 2)) {
      stop("ExtendMaximumAssignments must be between 2 and 25")
    }
    if ("ExtendMinimumTimeInSeconds" %in% names(l) &&
        (as.numeric(l$ExtendMinimumTimeInSeconds) > 31536000 |
         as.numeric(l$ExtendMinimumTimeInSeconds) < 3600)) {
      stop("ExtendMinimumTimeInSeconds must be between one hour and one year")
    }
    if(!exists("AnswerKey", l)){
      stop("AnswerKey is missing")
    }

    # Build AnswerKey MapEntries
    a$Parameters[[1]] <- list("Key" = "AnswerKey", "MapEntries" = list())
    maps <- l$AnswerKey

    a$Parameters[[1]]$MapEntries <- list()

    for (i in 1:length(maps)) {
      key <- names(maps)[i]
      values <- maps[[i]]
      a$Parameters[[1]]$MapEntries[[i]] <- dict("Key" = key, "Values" = list(as.character(values)))
    }
    l$AnswerKey <- NULL

    if(length(l) == 0){
      stop("Missing other parameters")
    }

    # Check other parameters
    for (i in 1:length(l)) {
      # Check that parameters are allowed
      if (!names(l)[i] %in% c("ApproveIfKnownAnswerScoreIsAtLeast",
                              "ApproveReason", "RejectIfKnownAnswerScoreIsLessThan",
                              "RejectReason", "ExtendIfKnownAnswerScoreIsLessThan",
                              "ExtendMaximumAssignments", "ExtendMinimumTimeInSeconds")) {
        stop(paste0("Inappropriate Assignment ReviewPolicy Parameter: ",names(l)[i]))
      }

      key <- names(l)[i]
      values <- l[[i]]
      a$Parameters[[i+1]] <- list("Key" = key, "Values" = list(as.character(values)))
    }

    # Convert to dictionary objects
    for (i in 1:length(a$Parameters)) {
      a$Parameters[[i]] <- reticulate::dict(a$Parameters[[i]])
    }

    a <- reticulate::dict(a)
    return(a)
  }
