#' Reject Assignment
#'
#' Reject a Worker's assignment (or multiple assignments) submitted for a HIT.
#' Feedback should be provided for why an assignment was rejected.
#'
#' Reject assignments, by AssignmentId (as returned by
#' \code{\link{GetAssignment}}). More advanced functionality to quickly reject
#' many or all assignments (ala \code{\link{ApproveAllAssignments}}) is
#' intentionally not provided.
#'
#' \code{RejectAssignments()} and \code{reject()} are aliases.
#'
#' @aliases RejectAssignment RejectAssignments reject
#' @param assignments A character string containing an AssignmentId, or a
#' vector of multiple character strings containing multiple AssignmentIds, to
#' reject.
#' @param feedback A character string containing any feedback for a
#' worker. This must have length 1 or length equal to the number of workers.
#' @param verbose Optionally print the results of the API request to the
#' standard output. Default is taken from \code{getOption('pyMTurkR.verbose',
#' TRUE)}.
#' @return A data frame containing the list of AssignmentIds, feedback (if
#' any), and whether or not each rejection request was valid.
#' @author Tyler Burleigh, Thomas J. Leeper
#' @seealso \code{\link{ApproveAssignment}}
#' @references
#' \href{https://docs.aws.amazon.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_RejectAssignmentOperation.html}{API Reference}
#' @keywords Assignments
#' @examples
#'
#' \dontrun{
#' RejectAssignment(assignments = "26XXH0JPPSI23H54YVG7BKLEXAMPLE")
#' }
#'
#' @export RejectAssignment
#' @export RejectAssignments
#' @export reject

RejectAssignment <-
  RejectAssignments <-
  reject <-
  function (assignments,
            feedback,
            verbose = getOption('pyMTurkR.verbose', TRUE)){

    GetClient() # Boto3 client

    if (is.factor(assignments)) {
      assignments <- as.character(assignments)
    }
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

    # Data frame to hold results
    Assignments <- emptydf(0, 3, c("AssignmentId", "Feedback", "Valid"))

    # Loop through assignments and approve
    for (i in 1:length(assignments)){

      response <- try(pyMTurkR$Client$reject_assignment(
        AssignmentId = assignments[i],
        RequesterFeedback = feedback[i]
      ), silent = !verbose)

      # Check if failure
      if (inherits(response, "try-error")) {
        valid <- FALSE
        if (verbose) {
          warning(i, ": Invalid request for assignment ",assignments[i])
        }
      } else {
        valid <- TRUE
        if (verbose) {
          message(i, ": Assignment (", assignments[i], ") Rejected")
        }
      }

      # Add to data frame
      Assignments <- rbind(Assignments, data.frame(AssignmentId = assignments[i],
                                                   Feedback = feedback[i],
                                                   Valid = valid))
    }

    # Return results
    message(sum(Assignments$Valid), " Assignments Rejected")
    return(Assignments)
  }
