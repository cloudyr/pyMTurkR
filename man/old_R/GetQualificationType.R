#' Get QualificationType
#' 
#' Get the details of a Qualification Type.
#' 
#' Retrieve characteristics of a specified QualificationType (as originally
#' specified by \code{\link{CreateQualificationType}}).
#' 
#' \code{qualtype()} is an alias.
#' 
#' @aliases GetQualificationType qualtype
#' @param qual A character string containing a QualificationTypeId.
#' @param verbose Optionally print the results of the API request to the
#' standard output. Default is taken from \code{getOption('MTurkR.verbose',
#' TRUE)}.
#' @param ... Additional arguments passed to \code{\link{request}}.
#' @return A data frame containing the QualificationTypeId of the newly created
#' QualificationType and other details as specified in the request.
#' @author Thomas J. Leeper
#' @seealso \code{\link{CreateQualificationType}}
#' 
#' \code{\link{UpdateQualificationType}}
#' 
#' \code{\link{DisposeQualificationType}}
#' 
#' \code{\link{SearchQualificationTypes}}
#' @references
#' \href{http://docs.amazonwebservices.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_GetQualificationTypeOperation.htmlAPI
#' Reference}
#' @keywords Qualifications
#' @examples
#' 
#' \dontrun{
#' qual1 <- 
#' CreateQualificationType(name="Worked for me before",
#'     description="This qualification is for people who have worked for me before",
#'     status = "Active",
#'     keywords="Worked for me before")
#' GetQualificationType(qual1$QualificationTypeId)
#' DisposeQualificationType(qual1$QualificationTypeId)
#' }
#' 