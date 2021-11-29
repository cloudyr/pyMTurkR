#' Generate Notification
#'
#' Generate a HITType Notification data structure for use in
#' \code{\link{SetHITTypeNotification}}.
#'
#' Generate a Notification data structure for use in the \code{notification}
#' option of \code{\link{SetHITTypeNotification}}.
#'
#' @param destination Currently, a character string containing a complete email
#' address (if \code{transport="Email"}), the SQS URL (if
#' \code{transport="SQS"}) or the SNS topic (if \code{transport="SNS"})
#' @param transport Only \dQuote{\code{Email}}, \dQuote{\code{SQS}}
#' and \dQuote{\code{SNS}} are supported. AWS recommends the use of the SQS
#' transport.
#' @param event.type A character string containing one of:
#' \code{AssignmentAccepted}, \code{AssignmentAbandoned}, \code{AssignmentReturned},
#' \code{AssignmentSubmitted}, \code{AssignmentRejected}, \code{AssignmentApproved},
#' \code{HITCreated}, \code{HITExtended}, \code{HITDisposed}, \code{HITReviewable},
#' \code{HITCreated}, \code{HITExtended}, \code{HITDisposed}, \code{HITReviewable},
#' \code{HITExpired} (the default), or \code{Ping}.
#' @param version Version of the HITType Notification API to use. Intended only
#' for advanced users.
#' @return A dictionary object containing the Notification data structure.
#' @author Tyler Burleigh, Thomas J. Leeper
#' @seealso \code{\link{SetHITTypeNotification}}
#'
#' \code{\link{SendTestEventNotification}}
#' @references
#' \href{https://docs.aws.amazon.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_NotificationDataStructureArticle.html}{API Reference}
#'
#' \href{https://docs.aws.amazon.com/AWSMechTurk/latest/AWSMechanicalTurkRequester/Concepts_NotificationsArticle.html}{API Reference: Concept}
#' @keywords Notifications
#' @export

GenerateNotification <-
function (destination,
          transport = "Email",
          event.type,
          version = "2006-05-05") {

    validopts <- c("AssignmentAccepted", "AssignmentAbandoned", "AssignmentReturned",
                   "AssignmentSubmitted", "AssignmentRejected", "AssignmentApproved",
                   "HITCreated", "HITExtended", "HITDisposed", "HITReviewable", "HITExpired",
                   "Ping")
    if (!event.type %in% validopts) {
      stop(paste0("Inappropriate EventType specified. Must be one of: ", paste(validopts, sep = ", ")))
    }
    validtransport <- c("Email", "SQS", "SNS")
    if(!transport %in% validtransport) {
      stop(paste0("Inappropriate Transport specified. Must be one of: ", paste(validtransport, sep = ", ")))
    }

    notification <- reticulate::dict(
      Destination = as.character(destination),
      Transport = as.character(transport),
      Version = version,
      EventTypes = list(event.type)
    )

    return(notification)
}
