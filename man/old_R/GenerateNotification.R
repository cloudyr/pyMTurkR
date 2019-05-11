#' Generate Notification
#' 
#' Generate a HITType Notification data structure for use in
#' \code{\link{SetHITTypeNotification}}.
#' 
#' Generate a Notification data structure for use in the \code{notification}
#' option of \code{\link{SetHITTypeNotification}}.
#' 
#' @param destination Currently, a character string containing a complete email
#' address (if \code{transport="Email"}) or the SQS URL (if
#' \code{transport="SQS"}).
#' @param transport Currently only \dQuote{\code{Email}} and
#' \dQuote{\code{SQS}} are supported. AWS recommends the use of the SQS
#' transport.
#' @param event.type A character string containing one of:
#' \code{AssignmentAccepted}, \code{AssignmentAbandoned},
#' \code{AssignmentReturned}, \code{AssignmentSubmitted}, \code{HITReviewable},
#' \code{HITExpired}, or \code{Ping}.
#' @param version Version of the HITType Notification API to use. Intended only
#' for advanced users.
#' @param event.number Intended only for advanced users to construct custom
#' Notifications.
#' @return A character string containing a URL query parameter-formatted
#' Notification data structure.
#' @author Thomas J. Leeper
#' @seealso \code{\link{SetHITTypeNotification}}
#' 
#' \code{\link{SendTestEventNotification}}
#' @references
#' \href{http://docs.amazonwebservices.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_NotificationDataStructureArticle.htmlAPI
#' Reference}
#' 
#' \href{http://docs.amazonwebservices.com/AWSMechTurk/latest/AWSMechanicalTurkRequester/Concepts_NotificationsArticle.htmlAPI
#' Reference: Concept}
#' @keywords Notifications