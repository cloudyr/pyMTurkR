#' Approve Assignment(s)
#'
#' Approve one or more submitted assignments, or approve all assignments for a
#' given HIT or HITType. Also allows you to approve a previously rejected
#' assignment. This function spends money from your MTurk account.
#'
#' Approve assignments, by AssignmentId (as returned by
#' \code{\link{GetAssignment}} or by HITId or HITTypeId. Must specify
#' \code{assignments}.
#'
#' \code{ApproveAssignments()}, \code{approve_assignment()} and \code{approve()}
#' are aliases for \code{ApproveAssignment}.
#'
#' @aliases ApproveAssignment ApproveAssignments approve approve_assignment
#' @param assignments A character string containing an AssignmentId, or a
#' vector of multiple character strings containing multiple AssignmentIds, to
#' approve.
#' @param feedback An optional character string containing any feedback for a
#' worker. This must have length 1 or length equal to the number of workers.
#' Maximum of 1024 characters.
#' @param rejected A logical indicating whether the assignment(s) had
#' previously been rejected (default \code{FALSE}). Approval of previously
#' rejected assignments must be conducted separately from other approvals.
#' @return A data frame containing the list of AssignmentIds, feedback (if
#' any), and whether or not each approval request was valid.
#' @author Tyler Burleigh, Thomas J. Leeper
#' @seealso \code{\link{RejectAssignment}}
#' @references
#' \href{http://docs.amazonwebservices.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_ApproveAssignmentOperation.html}{API
#' Reference: Approve Assignment}
#'
#' \href{http://docs.amazonwebservices.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_ApproveRejectedAssignmentOperation.html}{API
#' Reference: Approve Rejected Assignment}
#' @keywords Assignments
#' @examples
#'
#' \dontrun{
#' # Approve one assignment
#' ApproveAssignment(assignments = "26XXH0JPPSI23H54YVG7BKLEXAMPLE")
#'
#' # Approve multiple assignments with the same feedback
#' ApproveAssignment(assignments = c("26XXH0JPPSI23H54YVG7BKLEXAMPLE1",
#'                                   "26XXH0JPPSI23H54YVG7BKLEXAMPLE2"),
#'                   feedback = "Great work!")
#' }
#'

ApproveAssignment <-
ApproveAssignments <-
approve <-
approve_assignment <-
function (assignments,
          feedback = "",
          rejected = FALSE) {

  client <- GetClient() # Boto3 client

  if (is.factor(assignments)) {
      assignments <- as.character(assignments)
  }
  if (!is.null(feedback)) {
    if (is.factor(feedback)) {
        feedback <- as.character(feedback)
    }
    for (i in 1:length(feedback)) {
        if (!is.null(feedback[i]) && nchar(feedback[i]) > 1024)
            warning("Feedback ", i, " is too long (1024 char max)")
    }
    if (length(feedback) == 1) {
        feedback <- rep(feedback[1], length(assignments))
    } else if (!length(feedback) == length(assignments)) {
        stop("Number of feedback is not 1 nor length(assignments)")
    }
  }

  # Data frame to hold results
  results <- data.frame(AssignmentId = character(), Feedback = character(), Valid = logical())

  # Loop through assignments and approve
  for (i in 1:length(assignments)){

    a <- assignments[i]
    f <- feedback[i]
    result <- try(client$approve_assignment(
      AssignmentId = a,
      RequesterFeedback = f,
      OverrideRejection = rejected
    ), silent = TRUE)

    # Validity check
    if(class(result) == "try-error") valid = FALSE
    else valid = TRUE

    # Add to data frame
    results <- rbind(results, data.frame(AssignmentId = a, Feedback = f, Valid = valid))
  }

  # Return results
  message(sum(results$Valid), " Assignments Approved")
  results
}
