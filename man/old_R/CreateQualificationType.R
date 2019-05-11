#' Create QualificationType
#' 
#' Create a QualificationType. This creates a QualificationType, but does not
#' assign it to any workers. All characteristics of the QualificationType
#' (except name and keywords) can be changed later with
#' \code{\link{UpdateQualificationType}}.
#' 
#' A function to create a QualificationType. Active QualificationTypes are
#' visible to workers and to other requesters. All characteristics of the
#' QualificationType, other than the name and keywords, can later be modified
#' by \code{\link{UpdateQualificationType}}. Qualifications can then be used to
#' assign Qualifications to workers with \code{\link{AssignQualification}} and
#' invoked as QualificationRequirements in \code{\link{RegisterHITType}} and/or
#' \code{\link{CreateHIT}} operations.
#' 
#' \code{createqual()} is an alias.
#' 
#' @aliases CreateQualificationType createqual
#' @param name A name for the QualificationType. This is visible to workers. It
#' cannot be modified by \code{\link{UpdateQualificationType}}.
#' @param description A longer description of the QualificationType. This is
#' visible to workers. Maximum of 2000 characters.
#' @param status A character vector of \dQuote{Active} or \dQuote{Inactive},
#' indicating whether the QualificationType should be active and visible.
#' @param keywords An optional character string containing a comma-separated
#' set of keywords by which workers can search for the QualificationType.
#' Maximum 1000 characters. These cannot be modified by
#' \code{\link{UpdateQualificationType}}.
#' @param retry.delay An optional time (in seconds) indicating how long workers
#' have to wait before requesting the QualificationType after an initial
#' rejection. If not specified, retries are disabled and Workers can request a
#' Qualification of this type only once, even if the Worker has not been
#' granted the Qualification.
#' @param test An optional character string consisting of a QuestionForm data
#' structure, used as a test a worker must complete before the
#' QualificationType is granted to them.
#' @param answerkey An optional character string consisting of an AnswerKey
#' data structure, used to automatically score the test, perhaps as returned by
#' \code{\link{GenerateAnswerKey}}.
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
#' granted to workers who request it. Default is \code{NULL} meaning
#' \code{FALSE}.
#' @param auto.value An optional parameter specifying the value that is
#' automatically assigned to workers when they request it (if the Qualification
#' is automatically granted).
#' @param verbose Optionally print the results of the API request to the
#' standard output. Default is taken from \code{getOption('MTurkR.verbose',
#' TRUE)}.
#' @param ... Additional arguments passed to \code{\link{request}}.
#' @return A data frame containing the QualificationTypeId and other details of
#' the newly created QualificationType.
#' @author Thomas J. Leeper
#' @seealso \code{\link{GetQualificationType}}
#' 
#' \code{\link{DisposeQualificationType}}
#' 
#' \code{\link{UpdateQualificationType}}
#' 
#' \code{\link{SearchQualificationTypes}}
#' @references
#' \href{http://docs.amazonwebservices.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_CreateQualificationTypeOperation.htmlAPI
#' Reference}
#' @keywords Qualifications
#' @examples
#' 
#' \dontrun{
#' # Create 
#' qual1 <- CreateQualificationType(name="Worked for me before",
#'            description="This qualification is for people who have worked for me before",
#'            status = "Active",
#'            keywords="Worked for me before")
#' DisposeQualificationType(qual1$QualificationTypeId)
#' }
#' 
#' \dontrun{
#' # QualificationType with test and answer key
#' qf <- paste0(readLines(system.file("qualificationtest1.xml", package = "MTurkR")), collapse="")
#' qa <- paste0(readLines(system.file("answerkey1.xml", package = "MTurkR")), collapse="")
#' qual1 <- CreateQualificationType(name = "Qualification with Test",
#'            description = "This qualification is a demo",
#'            test = qf,
#'            answerkey = qa, # optionally, use AnswerKey
#'            status = "Active",
#'            keywords = "test, autogranted")
#' DisposeQualificationType(qual1$QualificationTypeId)
#' }
#' 
#' 