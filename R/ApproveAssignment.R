#' Approve Assignment(s)
#'
#' Approve one or more submitted assignments, or approve all assignments for a
#' given HIT or HITType. Also allows you to approve a previously rejected
#' assignment. This function spends money from your MTurk account.
#'
#' Approve assignments, by AssignmentId (as returned by
#' \code{\link{GetAssignment}} or by HITId or HITTypeId. Must specify
#' \code{assignments}. \code{ApproveAllAssignments} approves all assignments of a given HIT or
#' HITType without first having to perform \code{\link{GetAssignment}}.
#'
#' \code{ApproveAssignments()} and \code{approve()} are aliases for \code{ApproveAssignment}.
#' \code{approveall()} is an alias for \code{ApproveAllAssignments}.
#'
#' @aliases ApproveAssignment ApproveAssignments approve approve ApproveAllAssignments
#' approveall
#' @param assignments A character string containing an AssignmentId, or a
#' vector of multiple character strings containing multiple AssignmentIds, to
#' approve.
#' @param feedback An optional character string containing any feedback for a
#' worker. This must have length 1 or length equal to the number of workers.
#' Maximum of 1024 characters.
#' @param rejected A logical indicating whether the assignment(s) had
#' previously been rejected (default \code{FALSE}), or a vector of logicals.
#' @param verbose Optionally print the results of the API request to the
#' standard output. Default is taken from \code{getOption('pyMTurkR.verbose',
#' TRUE)}.
#' @return A data frame containing the list of AssignmentIds, feedback (if
#' any), whether previous rejections were to be overriden,
#' and whether or not each approval request was valid.
#' @author Tyler Burleigh, Thomas J. Leeper
#' @seealso \code{\link{RejectAssignment}}
#' @references
#' \href{https://docs.aws.amazon.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_ApproveAssignmentOperation.html}{API
#' Reference: Approve Assignment}
#'
#' \href{https://docs.aws.amazon.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_ApproveRejectedAssignmentOperation.html}{API
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
#' @export ApproveAssignment
#' @export ApproveAssignments
#' @export approve
#' @export approve
#' @export ApproveAllAssignments
#' @export approveall

ApproveAssignment <-
ApproveAssignments <-
approve <-
function (assignments,
          feedback = NULL,
          rejected = FALSE,
          verbose = getOption('pyMTurkR.verbose', TRUE)) {

  GetClient() # Boto3 client

  if (is.factor(assignments)) {
      assignments <- as.character(assignments)
  }
  if (!is.null(feedback)) {
    if (is.factor(feedback)) {
        feedback <- as.character(feedback)
    }
    for (i in 1:length(feedback)) {
        if (!is.null(feedback[i]) && nchar(feedback[i]) > 1024)
            stop("Feedback ", i, " is too long (1024 char max)")
    }
    if (length(feedback) == 1) {
        feedback <- rep(feedback[1], length(assignments))
    } else if (!length(feedback) == length(assignments)) {
        stop("Number of feedback is not 1 nor length(assignments)")
    }
  }
  if (!length(rejected) == length(assignments)) {
    if (length(rejected) == 1) {
      rejected <- rep(rejected[1], length(assignments))
    } else {
      stop("Number of rejected is not 1 or number of Values")
    }
  }

  # Data frame to hold results
  Assignments <- emptydf(0, 4, c("AssignmentId",
                                 "Feedback",
                                 "OverrideRejection",
                                 "Valid"))

  # Loop through assignments and approve
  for (i in 1:length(assignments)){

    fun <- pyMTurkR$Client$approve_assignment

    args <- list(AssignmentId = assignments[i],
                 OverrideRejection = rejected[i])

    if(!is.null(feedback[i])){
      args <- c(args, list(RequesterFeedback = feedback[i]))
      this.feedback <- feedback[i]
    } else {
      this.feedback <- ""
    }

    # Execute the API call
    response <- try(
      do.call('fun', args), silent = !verbose
    )

    # Check if failure
    if (class(response) != "try-error") {
      valid <- TRUE
      if (verbose) {
        message(i, ": Assignment (", assignments[i], ") Approved")
      }
    } else {
      valid <- FALSE
      if (verbose) {
        warning(i, ": Invalid request for assignment ", assignments[i])
      }
    }

    # Add to data frame
    Assignments <- rbind(Assignments, data.frame(AssignmentId = assignments[i],
                                                 Feedback = this.feedback,
                                                 OverrideRejection = rejected[i],
                                                 Valid = valid))

  }

  # Return results
  if(verbose){
    message(sum(Assignments$Valid), " Assignments Approved")
  }
  return(Assignments)
}
