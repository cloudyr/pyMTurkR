#' Test a Notification
#'
#' Test a HITType Notification, for example, to try out a HITType Notification
#' before creating a HIT.
#'
#' Test a Notification configuration. The test mimics whatever the Notification
#' configuration will do when the event described in \code{test.event.type}
#' occurs. For example, if a Notification has been configured to send an email
#' any time an Assignment is Submitted, testing for an AssignmentSubmitted
#' event should trigger an email. Similarly, testing for an AssignmentReturned
#' event should do nothing.
#'
#' \code{notificationtest} is an alias.
#'
#' @aliases SendTestEventNotification notificationtest
#' @param notification A dictionary object Notification structure (e.g., returned by \code{\link{GenerateNotification}}).
#' @param test.event.type A character string containing one of:
#' \code{AssignmentAccepted}, \code{AssignmentAbandoned}, \code{AssignmentReturned},
#' \code{AssignmentSubmitted}, \code{AssignmentRejected}, \code{AssignmentApproved},
#' \code{HITCreated}, \code{HITExtended}, \code{HITDisposed}, \code{HITReviewable},
#' \code{HITCreated}, \code{HITExtended}, \code{HITDisposed}, \code{HITReviewable},
#' \code{HITExpired} (the default), or \code{Ping}.
#' @param verbose Optionally print the results of the API request to the
#' standard output. Default is taken from \code{getOption('pyMTurkR.verbose',
#' TRUE)}.
#' @return A data frame containing the notification, the event type, and
#' details on whether the request was valid. As a side effect, a notification
#' will be sent to the configured destination (either an email or an SQS
#' queue).
#' @author Tyler Burleigh, Thomas J. Leeper
#' @seealso \code{\link{SetHITTypeNotification}}
#' @references
#' \href{https://docs.aws.amazon.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_SendTestEventNotificationOperation.html}{API Reference}
#' @keywords Notifications
#' @examples
#'
#' \dontrun{
#' hittype <- RegisterHITType(title="10 Question Survey",
#'                            description = "Complete a 10-question survey",
#'                            reward = ".20",
#'                            duration = seconds(hours = 1),
#'                            keywords = "survey, questionnaire, politics")
#'
#' a <- GenerateNotification("requester@example.com", event.type = "HITExpired")
#'
#' SetHITTypeNotification(hit.type = hittype$HITTypeId,
#'                        notification = a,
#'                        active = TRUE)
#' }
#'
#' @export SendTestEventNotification
#' @export notificationtest

SendTestEventNotification <-
  notificationtest <-
  function (notification,
            test.event.type,
            verbose = getOption('pyMTurkR.verbose', TRUE)) {

    GetClient() # Boto3 client

    validopts <- c("AssignmentAccepted", "AssignmentAbandoned", "AssignmentReturned",
                   "AssignmentSubmitted", "AssignmentRejected", "AssignmentApproved",
                   "HITCreated", "HITExtended", "HITDisposed", "HITReviewable", "HITExpired",
                   "Ping")
    if (!test.event.type %in% validopts) {
      stop(paste0("Inappropriate TestEventType specified. Must be one of: ",
                  paste(validopts, collapse = ", ")))
    }

    # List to store arguments
    args <- list()

    # Set the function to use later (this one has a hit type)
    fun <- pyMTurkR$Client$send_test_event_notification

    args <- list(Notification = notification,
                 TestEventType = test.event.type)

    # Execute the API call
    response <- try(
      do.call('fun', args), silent = !verbose
    )

    # Check if failure
    if (!(inherits(response, "try-error"))) {
      valid <- TRUE
      if (verbose) {
        message("TestEventNotification ", test.event.type," Sent")
      }
    } else {
      valid <- FALSE
      if (verbose) {
        warning("Invalid Request")
      }
    }

    TestEvent <- emptydf(1, 4, c("Destination",
                                 "Transport",
                                 "TestEventType",
                                 "Valid"))
    TestEvent[1, ] <- c(as.character(notification$Destination),
                        as.character(notification$transport), test.event.type, valid)

    TestEvent$Valid <- factor(TestEvent$Valid, levels=c('TRUE','FALSE'))
    return(TestEvent)
  }
