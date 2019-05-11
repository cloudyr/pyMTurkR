#' Approve Assignment(s)
#' 
#' Approve one or more submitted assignments, or approve all assignments for a
#' given HIT or HITType. Also allows you to approve a previously rejected
#' assignment. This function spends money from your MTurk account.
#' 
#' Approve assignments, by AssignmentId (as returned by
#' \code{\link{GetAssignment}} or by HITId or HITTypeId. Must specify
#' \code{assignments} xor \code{hit} xor \code{hit.type}.
#' \code{ApproveAllAssignments} approves all assignments of a given HIT or
#' HITType without first having to perform \code{\link{GetAssignment}}.
#' 
#' \code{ApproveAssignments()} and \code{approve()} are aliases for
#' \code{ApproveAssignment}. \code{approveall()} is an alias for
#' \code{ApproveAllAssignments}.
#' 
#' @aliases ApproveAssignment ApproveAssignments approve ApproveAllAssignments
#' approveall
#' @param assignments A character string containing an AssignmentId, or a
#' vector of multiple character strings containing multiple AssignmentIds, to
#' approve.
#' @param hit A character string containing a HITId all of whose assignments
#' are to be approved. Must specify \code{hit} xor \code{hit.type} xor
#' \code{annotation}.
#' @param hit.type A character string containing a HITTypeId (or a vector of
#' HITTypeIds) all of whose HITs' assignments are to be approved. Must specify
#' \code{hit} xor \code{hit.type} xor \code{annotation}.
#' @param annotation An optional character string specifying the value of the
#' \code{RequesterAnnotation} field for a batch of HITs. This can be used to
#' approve all assignments for all HITs from a \dQuote{batch} created in the
#' online Requester User Interface (RUI). To use a batch ID, the batch must be
#' written in a character string of the form \dQuote{BatchId:78382;}, where
#' \dQuote{73832} is the batch ID shown in the RUI. Must specify \code{hit} xor
#' \code{hit.type} xor \code{annotation}.
#' @param feedback An optional character string containing any feedback for a
#' worker. This must have length 1 or length equal to the number of workers.
#' Maximum of 1024 characters. For \code{ApproveAllAssignments}, must be length
#' 1.
#' @param rejected A logical indicating whether the assignment(s) had
#' previously been rejected (default \code{FALSE}). Approval of previously
#' rejected assignments must be conducted separately from other approvals.
#' @param verbose Optionally print the results of the API request to the
#' standard output. Default is taken from \code{getOption('MTurkR.verbose',
#' TRUE)}.
#' @param ... Additional arguments passed to \code{\link{request}}.
#' @return A data frame containing the list of AssignmentIds, feedback (if
#' any), and whether or not each approval request was valid.
#' @author Thomas J. Leeper
#' @seealso \code{\link{RejectAssignment}}
#' @references
#' \href{http://docs.amazonwebservices.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_ApproveAssignmentOperation.htmlAPI
#' Reference: Approve Assignment}
#' 
#' \href{http://docs.amazonwebservices.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_ApproveRejectedAssignmentOperation.htmlAPI
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
#' 
#' 
#' # Approve all assignments for a given HIT
#' ApproveAllAssignments(hit = "2MQB727M0IGF304GJ16S1F4VE3AYDQ")
#' # Approve all assignments for a given HITType
#' ApproveAllAssignments(hit.type = "2FFNCWYB49F9BBJWA4SJUNST5OFSOW")
#' # Approve all assignments for a given batch from the RUI
#' ApproveAllAssignments(annotation="BatchId:78382;")
#' }
#' 