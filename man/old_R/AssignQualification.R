#' Assign Qualification
#' 
#' Assign a Qualification to one or more workers. The QualificationType should
#' have already been created by \code{\link{CreateQualificationType}}, or the
#' details of a new QualificationType can be specified atomically. This
#' function also provides various options for automatically specifying the
#' value of a worker's QualificationScore based upon a worker's statistics.
#' 
#' A very robust function to assign a Qualification to one or more workers. The
#' simplest use of the function is to assign a Qualification of the specified
#' value to one worker, but assignment to multiple workers is possible. Workers
#' can be assigned a Qualification previously created by
#' \code{\link{CreateQualificationType}}, with the characteristics of a new
#' QualificationType specified atomically, or a QualificationTypeID for a
#' qualification created in the MTurk RUI. Qualifications can also be assigned
#' conditional on each worker's value of a specified statistic (including
#' assigning the value of the specified statistic as the worker's score for the
#' Qualification).
#' 
#' \code{AssignQualifications()} and \code{assignqual()} are aliases.
#' 
#' @aliases AssignQualification AssignQualifications assignqual
#' @param qual A character string containing a QualificationTypeId.
#' @param workers A character string containing a WorkerId, or a vector of
#' character strings containing multiple WorkerIds.
#' @param value A character string containing the value to be assigned to the
#' worker(s) for the QualificationType.
#' @param notify A logical indicating whether workers should be notified that
#' they have been assigned the qualification. Default is \code{FALSE}.
#' @param name An optional character string specifying a name for a new
#' QualificationType. This is visible to workers. Cannot be modified by
#' \code{UpdateQualificationType}.
#' @param description An optional character string specifying a longer
#' description of the QualificationType. This is visible to workers. Maximum of
#' 2000 characters.
#' @param keywords An optional character string containing a comma-separated
#' set of keywords by which workers can search for the QualificationType.
#' Cannot be modified by \code{UpdateQualificationType}. Maximum of 1000
#' characters.
#' @param status A character vector of \dQuote{Active} or \dQuote{Inactive},
#' indicating whether the QualificationType should be active and visible.
#' @param retry.delay An optional time (in seconds) indicating how long workers
#' have to wait before requesting the QualificationType after an initial
#' rejection.
#' @param test An optional character string consisting of a QuestionForm data
#' structure, used as a test a worker must complete before the
#' QualificationType is granted to them.
#' @param answerkey An optional character string consisting of an AnswerKey
#' data structure, used to automatically score the test.
#' @param test.duration An optional time (in seconds) indicating how long
#' workers have to complete the test.
#' @param auto A logical indicating whether the Qualification is automatically
#' granted to workers who request it. Default is \code{FALSE}.
#' @param auto.value An optional parameter specifying the value that is
#' automatically assigned to workers when they request it (if the Qualification
#' is automatically granted).
#' @param conditional.statistic An optional character string containing the
#' name of a statistic (see \code{\link{ListStatistics}} that should be used to
#' conditionally assign the QualificationType to workers.
#' @param conditional.comparator An optional character string containing a
#' comparator by which a worker's score of a qualification is compared to the
#' specified \code{value}. One of \dQuote{<}, \dQuote{<=}, \dQuote{>},
#' \dQuote{>=}, \dQuote{==}, \dQuote{!=}, \dQuote{Exists}, or
#' \dQuote{DoesNotExist}.
#' @param conditional.value An optional numeric or character string value
#' against which workers scores will be compared. The QualificationType will
#' only be assigned to those whose score on the specified statistic meet the
#' comparison to this value.
#' @param conditional.period An optional character string specifying the period
#' for the statistic. Must be one of: \dQuote{OneDay}, \dQuote{SevenDays},
#' \dQuote{ThirtyDays}, \dQuote{LifeToDate}. Default is \dQuote{LifeToDate}.
#' @param set.statistic.as.value An optional logical specifying whether the
#' worker's value of the statistic should be used as the value they are
#' assigned for the QualificationType. Default is \code{FALSE} and \code{value}
#' is used instead.
#' @param verbose Optionally print the results of the API request to the
#' standard output. Default is taken from \code{getOption('MTurkR.verbose',
#' TRUE)}.
#' @param ... Additional arguments passed to \code{\link{request}}.
#' @return A data frame containing the list of workers, the
#' QualificationTypeId, the value each worker was assigned, whether they were
#' notified of their QualificationType assignment, and whether the request was
#' valid.
#' @author Thomas J. Leeper
#' @seealso \code{\link{CreateQualificationType}}
#' 
#' \code{\link{UpdateQualificationScore}}
#' @references
#' \href{http://docs.amazonwebservices.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_AssignQualificationOperation.htmlAPI
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
#' 
#' # assign qualification to single worker
#' AssignQualification(qual1$QualificationTypeId, "A1RO9UJNWXMU65", value = "50")
#' 
#' # assign a new qualification (defined atomically)
#' AssignQualification(workers = "A1RO9UJNWXMU65",
#'                     name = "Worked for me before",
#'                     description = "This qualification is for people who have worked for me before",
#'                     status = "Active",
#'                     keywords = "Worked for me before")
#' 
#' # assign a qualification to a workers based upon their worker statistic
#' AssignQualification(qual1$QualificationTypeId,
#'     workers="A1RO9UJNWXMU65",
#'     conditional.statistic="NumberAssignmentsApproved",
#'     conditional.comparator=">", 
#'     conditional.value="5", 
#'     conditional.period="LifeToDate", 
#'     set.statistic.as.value=TRUE)
#' 
#' DisposeQualificationType(qual1$QualificationTypeId)
#' }
#' 