#' Get HIT
#' 
#' Retrieve various details of a HIT as a data frame. What details are returned
#' depend upon the requested ResponseGroup.
#' 
#' \code{GetHIT} retrieves characteristics of a HIT. \code{HITStatus} is a
#' wrapper that retrieves the Number of Assignments Pending, Number of
#' Assignments Available, Number of Assignments Completed for the HIT(s), which
#' is helpful for checking on the progress of currently available HITs.
#' Specifying a \code{hit.type} causes the function to first search for
#' available HITs of that HITType, then return the requested information for
#' each HIT.
#' 
#' \code{gethit()} and \code{hit()} are aliases for \code{GetHIT}.
#' \code{status()} is an alias for \code{HITStatus}.
#' 
#' @aliases GetHIT gethit hit HITStatus status
#' @param hit An optional character string specifying the HITId of the HIT to
#' be retrieved. Must specify \code{hit} xor \code{hit.type} xor
#' \code{annotation}.
#' @param hit.type An optional character string specifying the HITTypeId (or a
#' vector of HITTypeIds) of the HIT(s) to be retrieved. Must specify \code{hit}
#' xor \code{hit.type} xor \code{annotation}, otherwise all HITs are returned
#' in \code{HITStatus}.
#' @param annotation An optional character string specifying the value of the
#' \code{RequesterAnnotation} field for a batch of HITs. This can be used to
#' retrieve all HITs from a \dQuote{batch} created in the online Requester User
#' Interface (RUI). To use a batch ID, the batch must be written in a character
#' string of the form \dQuote{BatchId:78382;}, where \dQuote{73832} is the
#' batch ID shown in the RUI. Must specify \code{hit} xor \code{hit.type} xor
#' \code{annotation}, otherwise all HITs are returned in \code{HITStatus}.
#' @param response.group An optional character string (or vector of character
#' strings) specifying what details of each HIT to return of: \dQuote{Request},
#' \dQuote{Minimal}, \dQuote{HITDetail}, \dQuote{HITQuestion},
#' \dQuote{HITAssignmentSummary}. For more information, see
#' \href{http://docs.aws.amazon.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_CommonParametersArticle.htmlCommon
#' Parameters} and
#' \href{http://docs.amazonwebservices.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_HITDataStructureArticle.htmlHIT
#' Data Structure}.
#' @param return.hit.dataframe A logical indicating whether the data frame of
#' HITs should be returned. Default is \code{TRUE}.
#' @param return.qual.dataframe A logical indicating whether the list of each
#' HIT's QualificationRequirements (stored as data frames in that list) should
#' be returned. Default is \code{TRUE}.
#' @param verbose Optionally print the results of the API request to the
#' standard output. Default is taken from \code{getOption('MTurkR.verbose',
#' TRUE)}.
#' @param ... Additional arguments passed to \code{\link{request}}.
#' @return Optionally a one- or two-element list containing a data frame of HIT
#' details and, optionally, a list of each HIT's QualificationRequirements
#' (stored as data frames in that list in the order that HITs were retrieved.).
#' @author Thomas J. Leeper
#' @seealso \code{\link{GetHITsForQualificationType}}
#' 
#' \code{\link{GetReviewableHITs}}
#' 
#' \code{\link{SearchHITs}}
#' @references
#' \href{http://docs.amazonwebservices.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_GetHITOperation.htmlAPI
#' Reference}
#' @keywords HITs
#' @examples
#' 
#' \dontrun{
#' # register HITType
#' hittype <- 
#' RegisterHITType(title="10 Question Survey",
#'                 description=
#'                 "Complete a 10-question survey about news coverage and your opinions",
#'                 reward=".20", 
#'                 duration=seconds(hours=1), 
#'                 keywords="survey, questionnaire, politics")
#' 
#' a <- GenerateExternalQuestion("http://www.example.com/","400")
#' hit1 <- 
#' CreateHIT(hit.type = hittype$HITTypeId, question = a$string)
#' 
#' GetHIT(hit1$HITId)
#' HITStatus(hit1$HITId)
#' 
#' # cleanup
#' DisableHIT(hit1$HITId)
#' }
#' \dontrun{
#' # Get the status of all HITs from a given batch from the RUI
#' HITStatus(annotation="BatchId:78382;")
#' }
#' 