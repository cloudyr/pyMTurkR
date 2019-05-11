#' Dispose QualificationType
#' 
#' Dispose of a QualificationType. This deletes the QualificationType,
#' Qualification scores for all workers, and all records thereof.
#' 
#' A function to dispose of a QualificationType that is no longer needed. All
#' information about the QualificationType and all workers' Qualifications of
#' that type are permanently deleted.
#' 
#' \code{disposequal()} is an alias.
#' 
#' @aliases DisposeQualificationType disposequal
#' @param qual A character string containing a QualificationTypeId.
#' @param verbose Optionally print the results of the API request to the
#' standard output. Default is taken from \code{getOption('MTurkR.verbose',
#' TRUE)}.
#' @param ... Additional arguments passed to \code{\link{request}}.
#' @return A data frame containing the QualificationTypeId and whether the
#' request to dispose was valid.
#' @author Thomas J. Leeper
#' @seealso \code{\link{GetQualificationType}}
#' 
#' \code{\link{CreateQualificationType}}
#' 
#' \code{\link{UpdateQualificationType}}
#' 
#' \code{\link{SearchQualificationTypes}}
#' @references
#' \href{http://docs.amazonwebservices.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_DisposeQualificationTypeOperation.htmlAPI
#' Reference}
#' @examples
#' 
#' \dontrun{
#' qual1 <- 
#' CreateQualificationType(name="Worked for me before",
#'     description="This qualification is for people who have worked for me before",
#'     status = "Active",
#'     keywords="Worked for me before")
#' DisposeQualificationType(qual1$QualificationTypeId)
#' }
#' 