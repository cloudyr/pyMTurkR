#' Configure a HITType Notification
#' 
#' Configure a notification to be sent when specific actions occur for the
#' specified HITType.
#' 
#' Configure a notification to be sent to the requester whenever an event
#' (specified in the \code{Notification} object) occurs. This is useful, for
#' example, to enable email notifications about when assignments are submitted
#' or HITs are completed, or for other HIT-related events.
#' 
#' Email notifications are useful for small projects, but configuring
#' notifications to use the Amazon Simple Queue Service (SQS) is more reliable
#' for large projects and allows automated processing of notifications. See
#' examples for SQS examples. Note that using SQS requires an SQS queue with
#' permissions configured to allow \code{SendMessage} requests from MTurk (the
#' \dQuote{principal} for MTurk is
#' \code{arn:aws:iam::755651556756:user/MTurk-SQS}). See
#' \href{https://github.com/leeper/MTurkR/wiki/Notifications\#setup-sqs-notificationsthe
#' MTurkR wiki} for an extended tutorial.
#' 
#' \code{setnotification()} is an alias.
#' 
#' @aliases SetHITTypeNotification setnotification
#' @param hit.type A character string specifying the HITTypeId of the HITType
#' for which notifications are being configured.
#' @param notification A character string containing a URL query
#' parameter-formatted Notification structure (e.g., returned by
#' \code{\link{GenerateNotification}}).
#' @param active A logical indicating whether the Notification is active or
#' inactive.
#' @param verbose Optionally print the results of the API request to the
#' standard output. Default is taken from \code{getOption('MTurkR.verbose',
#' TRUE)}.
#' @param ... Additional arguments passed to \code{\link{request}}.
#' @return A data frame containing details of the Notification and whether or
#' not the request was successfully executed by MTurk.
#' 
#' Once configured, events will trigger a side effect in the form of a
#' notification sent to the specified transport (either an email address or SQS
#' queue). That notification will contain the following details:
#' \code{EventType}, \code{EventTime}, \code{HITTypeId}, \code{HITId}, and (if
#' applicable) \code{AssignmentId}.
#' @author Thomas J. Leeper
#' @seealso \code{\link{GenerateNotification}}
#' 
#' \code{\link{SendTestEventNotification}}
#' @references
#' \href{http://docs.amazonwebservices.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_SetHITTypeNotificationOperation.htmlAPI
#' Reference: Operation}
#' 
#' \href{http://docs.amazonwebservices.com/AWSMechTurk/latest/AWSMechanicalTurkRequester/Concepts_NotificationsArticle.htmlAPI
#' Reference: Concept}
#' @keywords Notifications
#' @examples
#' 
#' \dontrun{
#' # setup email notification
#' hittype <- 
#' RegisterHITType(title="10 Question Survey",
#'                 description=
#'                 "Complete a 10-question survey about news coverage and your opinions",
#'                 reward=".20", 
#'                 duration=seconds(hours=1), 
#'                 keywords="survey, questionnaire, politics")
#' 
#' a <- GenerateNotification("requester@example.com", event.type = "HITExpired")
#' SetHITTypeNotification(hit.type = hittype$HITTypeId, 
#'                        notification = a,
#'                        active = TRUE)
#' # send test notification
#' SendTestEventNotification(a, test.event.type="HITExpired")
#' }
#' 
#' \dontrun{
#' # setup SQS notification
#' hittype <- 
#' RegisterHITType(title="10 Question Survey",
#'                 description=
#'                 "Complete a 10-question survey about news coverage and your opinions",
#'                 reward=".20", 
#'                 duration=seconds(hours=1), 
#'                 keywords="survey, questionnaire, politics")
#' 
#' b <- GenerateNotification("https://sqs.us-east-1.amazonaws.com/123456789/Example", 
#'                           transport = "SQS", 
#'                           event.type = "HITExpired")
#' SetHITTypeNotification(hit.type = hittype$HITTypeId, 
#'                        notification = b,
#'                        active = TRUE)
#' # send test notification
#' SendTestEventNotification(b, test.event.type="HITExpired")
#' }
#' 