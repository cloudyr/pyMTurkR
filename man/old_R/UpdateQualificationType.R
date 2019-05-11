#' Update a Worker QualificationType
#' 
#' Update characteristics of a QualificationType.
#' 
#' A function to update the characteristics of a QualificationType. Name and
#' keywords cannot be modified after a QualificationType is created.
#' 
#' \code{updatequal()} is an alias.
#' 
#' @aliases UpdateQualificationType updatequal
#' @param qual A character string containing a QualificationTypeId.
#' @param description A character string describing the Qualification. This is
#' visible to workers. Maximum of 2000 characters.
#' @param status A character vector of \dQuote{Active} or \dQuote{Inactive},
#' indicating whether the QualificationType should be active and visible.
#' @param retry.delay An optional time (in seconds) indicating how long workers
#' have to wait before requesting the QualificationType after an initial
#' rejection.
#' @param test An optional character string consisting of a QuestionForm data
#' structure, used as a test a worker must complete before the
#' QualificationType is granted to them.
#' @param answerkey An optional character string consisting of an AnswerKey
#' data structure, used to automatically score the test. If a previous test
#' with an associated AnswerKey is updated, the new test will not have an
#' AnswerKey unless a new one is included in the same call (even if it is
#' identical to the previous AnswerKey).
#' @param test.duration An optional time (in seconds) indicating how long
#' workers have to complete the test.
#' @param validate.test A logical specifying whether the \code{test} parameter
#' should be validated against the relevant MTurk schema prior to creating the
#' QualificationType (operation will fail if it does not validate, and will
#' return validation information). Default is \code{FALSE}.
#' @param validate.answerkey A logical specifying whether the \code{answerkey}
#' parameter should be validated against the relevant MTurk schema prior to
#' creating the QualificationType (operation will fail if it does not validate,
#' and will return validation information). Default is \code{FALSE}.
#' @param auto A logical indicating whether the Qualification is automatically
#' granted to workers who request it. Default is \code{FALSE}.
#' @param auto.value An optional parameter specifying the value that is
#' automatically assigned to workers when they request it (if the Qualification
#' is automatically granted).
#' @param verbose Optionally print the results of the API request to the
#' standard output. Default is taken from \code{getOption('MTurkR.verbose',
#' TRUE)}.
#' @param ... Additional arguments passed to \code{\link{request}}.
#' @return A data frame containing the QualificationTypeId of the newly created
#' QualificationType and other details as specified in the request.
#' @author Thomas J. Leeper
#' @seealso \code{\link{GetQualificationType}}
#' 
#' \code{\link{CreateQualificationType}}
#' 
#' \code{\link{DisposeQualificationType}}
#' 
#' \code{\link{SearchQualificationTypes}}
#' @references
#' \href{http://docs.amazonwebservices.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_UpdateQualificationTypeOperation.htmlAPI
#' Reference}
#' @keywords Qualifications
#' @examples
#' 
#' \dontrun{
#' qual1 <- 
#' CreateQualificationType(name="Worked for me before",
#'     description="This qualification is for people who have worked for me before",
#'     status = "Active",
#'     keywords="Worked for me before")
#' qual2 <- 
#' UpdateQualificationType(qual1$QualificationTypeId,
#'     description="This qualification is for everybody!",
#'     auto=TRUE, auto.value="5")
#' DisposeQualificationType(qual1$QualificationTypeId)
#' }
#' 