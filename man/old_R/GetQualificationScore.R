#' Get a Worker's Qualification Score
#' 
#' Get a Worker's score for a specific Qualification. You can only retrieve
#' scores for custom QualificationTypes. Scores for built-in QualificationTypes
#' should be retrieved with \code{\link{GetWorkerStatistic}}.
#' 
#' A function to retrieve one or more scores for a specified QualificationType.
#' To retrieve all Qualifications of a given QualificationType, use
#' \code{\link{GetQualifications}} instead. Both \code{qual} and \code{workers}
#' can be vectors. If \code{qual} is not length 1 or the same length as
#' \code{workers}, an error will occur.
#' 
#' \code{qualscore()} is an alias.
#' 
#' @aliases GetQualificationScore qualscore
#' @param qual A character string containing a QualificationTypeId for a custom
#' QualificationType.
#' @param workers A character string containing a WorkerId, or a vector of
#' character strings containing multiple WorkerIds, whose Qualification Scores
#' you want to retrieve.
#' @param verbose Optionally print the results of the API request to the
#' standard output. Default is taken from \code{getOption('MTurkR.verbose',
#' TRUE)}.
#' @param ... Additional arguments passed to \code{\link{request}}.
#' @return A data frame containing the QualificationTypeId, WorkerId, time the
#' qualification was granted, the Qualification score, a column indicating the
#' status of the qualification, and a column indicating whether the API request
#' was valid.
#' @author Thomas J. Leeper
#' @seealso \code{\link{UpdateQualificationScore}}
#' 
#' \code{\link{GetQualifications}}
#' @references
#' \href{http://docs.amazonwebservices.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_GetQualificationScoreOperation.htmlAPI
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
#' GetQualificationScore(qual1$QualificationTypeId, qual1$WorkerId)
#' 
#' # cleanup
#' DisposeQualificationType(qual1$QualificationTypeId)
#' }
#' 