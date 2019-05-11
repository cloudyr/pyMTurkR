#' Get HITs by Qualification
#' 
#' Retrieve HITs according to the QualificationTypes that are required to
#' complete those HITs.
#' 
#' A function to retrieve HITs that require the specified QualificationType.
#' 
#' \code{gethitsbyqual()} is an alias.
#' 
#' @aliases GetHITsForQualificationType gethitsbyqual
#' @param qual A character string containing a QualificationTypeId.
#' @param response.group An optional character string specifying what details
#' of each HIT to return of: \dQuote{Minimal}, \dQuote{Request}. For more
#' information, see
#' \href{http://docs.aws.amazon.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_CommonParametersArticle.htmlCommon
#' Parameters} and
#' \href{http://docs.amazonwebservices.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_HITDataStructureArticle.htmlHIT
#' Data Structure}.
#' @param return.all A logical indicating whether all QualificationTypes (as
#' opposed to a specified page of the search results) should be returned.
#' Default is \code{TRUE}.
#' @param pagenumber An optional character string indicating which page of
#' search results should be returned. Most users can ignore this.
#' @param pagesize An optional character string indicating how many search
#' results should be returned by each request, between 1 and 100. Most users
#' can ignore this.
#' @param verbose Optionally print the results of the API request to the
#' standard output. Default is taken from \code{getOption('MTurkR.verbose',
#' TRUE)}.
#' @param ... Additional arguments passed to \code{\link{request}}.
#' @return A data frame containing the HITId and other requested
#' characteristics of the qualifying HITs.
#' @author Thomas J. Leeper
#' @seealso \code{\link{GetHIT}}
#' 
#' \code{\link{SearchHITs}}
#' @references
#' \href{http://docs.amazonwebservices.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_GetHITsForQualificationTypeOperation.htmlAPI
#' Reference}
#' @keywords HITs Qualifications
#' @examples
#' 
#' \dontrun{
#' q <- ListQualificationTypes()[7,2] # Location requirement
#' GetHITsForQualificationType(q)
#' }
#' 