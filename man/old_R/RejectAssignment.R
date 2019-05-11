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
#' @param feedback An optional character string containing any feedback for a
#' worker. This must have length 1 or length equal to the number of workers.
#' @param verbose Optionally print the results of the API request to the
#' standard output. Default is taken from \code{getOption('MTurkR.verbose',
#' TRUE)}.
#' @param ... Additional arguments passed to \code{\link{request}}.
#' @return A data frame containing the list of AssignmentIds, feedback (if
#' any), and whether or not each rejection request was valid.
#' @author Thomas J. Leeper
#' @seealso \code{\link{ApproveAssignment}}
#' @references
#' \href{http://docs.amazonwebservices.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_RejectAssignmentOperation.htmlAPI
#' Reference}
#' @keywords Assignments
#' @examples
#' 
#' \dontrun{
#' RejectAssignment(assignments="26XXH0JPPSI23H54YVG7BKLEXAMPLE")
#' }
#' 