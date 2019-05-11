#' Revoke a Qualification from a Worker
#' 
#' Revoke a Qualification from a worker or multiple workers. This deletes their
#' qualification score and any record thereof.
#' 
#' A simple function to revoke a Qualification assigned to one or more workers.
#' 
#' \code{RevokeQualifications()} and \code{revokequal()} are aliases.
#' 
#' @aliases RevokeQualification RevokeQualifications revokequal
#' @param qual A character string containing a QualificationTypeId.
#' @param worker A character string containing a WorkerId, or a vector of
#' character strings containing multiple WorkerIds.
#' @param reason An optional character string, or vector of character strings
#' of length equal to length of the \code{workers} parameter, supplying each
#' worker with a reason for revoking their Qualification. Workers will see this
#' message.
#' @param verbose Optionally print the results of the API request to the
#' standard output. Default is taken from \code{getOption('MTurkR.verbose',
#' TRUE)}.
#' @param ... Additional arguments passed to \code{\link{request}}.
#' @return A data frame containing the QualificationTypeId, WorkerId, reason
#' (if applicable), and whether each request was valid.
#' @author Thomas J. Leeper
#' @seealso \code{\link{GrantQualification}}
#' 
#' \code{\link{RejectQualification}}
#' @references
#' \href{http://docs.amazonwebservices.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_RevokeQualificationOperation.htmlAPI
#' Reference}
#' @keywords Qualifications
#' @examples
#' 
#' \dontrun{
#' qual1 <- 
#' AssignQualification(workers = "A1RO9UJNWXMU65",
#'                     name = "Worked for me before",
#'                     description = "This qualification is for people who have worked for me before",
#'                     status = "Active",
#'                     keywords = "Worked for me before")
#' 
#' RevokeQualification(qual = qual1$QualificationTypeId,
#'                     worker = qual1$WorkerId,
#'                     reason = "No longer needed")
#' 
#' DisposeQualificationType(qual1$QualificationTypeId)
#' 
#' }
#' 