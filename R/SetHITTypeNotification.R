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
#' for large projects and allows automated processing of notifications.
#'
#' \code{setnotification()} is an alias.
#'
#' @aliases SetHITTypeNotification setnotification
#' @param hit.type A character string specifying the HITTypeId of the HITType
#' for which notifications are being configured.
#' @param notification A dictionary object Notification structure (e.g., returned by
#' \code{\link{GenerateNotification}}).
#' @param active A logical indicating whether the Notification is active or
#' inactive.
#' @param verbose Optionally print the results of the API request to the
#' standard output. Default is taken from \code{getOption('pyMTurkR.verbose',
#' TRUE)}.
#' @return A data frame containing details of the Notification and whether or
#' not the request was successfully executed by MTurk.
#'
#' Once configured, events will trigger a side effect in the form of a
#' notification sent to the specified transport (either an email address or SQS
#' queue). That notification will contain the following details:
#' \code{EventType}, \code{EventTime}, \code{HITTypeId}, \code{HITId}, and (if
#' applicable) \code{AssignmentId}.
#'
#' Note that the 'Notification' column in this dataframe is a dictionary object
#' coerced into a character type. This cannot be used again directly as a notification
#' parameter, but it can be used to re-construct the dictionary object.
#' @author Tyler Burleigh, Thomas J. Leeper
#' @seealso \code{\link{GenerateNotification}}
#'
#' \code{\link{SendTestEventNotification}}
#' @references
#' \href{https://docs.aws.amazon.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_UpdateNotificationSettingsOperation.html}{API Reference: Operation}
#'
#' \href{http://docs.amazonwebservices.com/AWSMechTurk/latest/AWSMechanicalTurkRequester/Concepts_NotificationsArticle.html}{API Reference: Concept}
#' @keywords Notifications
#' @examples
#'
#' \dontrun{
#' # setup email notification
#' hittype <- RegisterHITType(title = "10 Question Survey",
#'                 description = "Complete a 10-question survey about news coverage and your opinions",
#'                 reward = ".20",
#'                 duration = seconds(hours=1),
#'                 keywords = "survey, questionnaire, politics")
#'
#' a <- GenerateNotification("user@gmail.com", "Email", "AssignmentAccepted")
#' SetHITTypeNotification(hit.type = hittype$HITTypeId,
#'                        notification = a,
#'                        active = TRUE)
#' # send test notification
#' SendTestEventNotification(a, test.event.type = "AssignmentAccepted")
#' }
#'

SetHITTypeNotification <-
  setnotification <-
  function (hit.type,
            notification = NULL,
            active = NULL,
            verbose = getOption('pyMTurkR.verbose', TRUE)){

    client <- GetClient() # Boto3 client

    # The function we'll call
    fun <- client$update_notification_settings

    # The arguments we'll call in the function
    args <- list()

    if (is.null(notification) & is.null(active)) {
      stop("Must specify either 'notification' and/or 'active'")
    }
    if (is.null(hit.type)) {
      stop("Must specify 'hit.type'")
    }
    if(!is.null(notification)){
      args <- c(args, Notification = notification)
    }
    if(!is.null(active)){
      if(is.na(as.logical(active))){
        stop("'active' must be TRUE or FALSE")
      } else {
        active <- as.logical(active)
        args <- c(args, Active = active)
      }
    }
    args <- c(args, HITTypeId = hit.type)

    Notification <- emptydf(1, 4, c("HITTypeId", "Notification", "Active", "Valid"))

    # Call the function with the arguments
    response <- try(do.call('fun', args))

    if(class(response) == "try-error") {
      valid = FALSE
    } else {
      valid = TRUE
    }

    Notification[1, ] <- c(hit.type, as.character(notification), active, valid)

    if (valid) {
      if (verbose) {
        if (!is.null(notification) & is.null(active)) {
          message("HITTypeNotification for ", hit.type, " Created")
        } else if (!is.null(notification) & !is.null(active) && active == TRUE) {
          message("HITTypeNotification for ", hit.type, " Created & Active")
        } else if (!is.null(notification) & !is.null(active) && active == FALSE) {
          message("HITTypeNotification for ", hit.type, " Created & Inactive")
        } else if (is.null(notification) & !is.null(active) && active == TRUE) {
          message("HITTypeNotification for ", hit.type, " Active")
        } else if (is.null(notification) & !is.null(active) && active == FALSE) {
          message("HITTypeNotification for ", hit.type, " Inactive")
        }
      }
    } else if (!valid & verbose) {
      warning("Invalid Request")
    }
    Notification$Valid <- factor(Notification$Valid, levels=c('TRUE','FALSE'))
    return(Notification)
  }
