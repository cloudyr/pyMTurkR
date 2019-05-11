#' Get Reviewable HITs
#' 
#' Get HITs that are currently reviewable.
#' 
#' A simple function to return the HITIds of HITs currently in
#' \dQuote{Reviewable} or \dQuote{Reviewing} status. To retrieve additional
#' details about each of these HITs, see \code{\link{GetHIT}}. This is an
#' alternative to \code{\link{SearchHITs}}.
#' 
#' \code{reviewable()} is an alias.
#' 
#' @aliases GetReviewableHITs reviewable
#' @param hit.type An optional character string containing a HITTypeId to
#' consider when looking for reviewable HITs.
#' @param status An optional character string of either \dQuote{Reviewable} or
#' \dQuote{Reviewing} limiting the search to HITs of with either status.
#' @param response.group A character string specifying what details of each HIT
#' to return. API currently only supports \dQuote{Minimal}. For more
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
#' @param sortproperty One of \dQuote{Title}, \dQuote{Reward},
#' \dQuote{Expiration}, \dQuote{CreationTime}, \dQuote{Enumeration}. Ignored if
#' \code{return.all=TRUE}. Most users can ignore this.
#' @param sortdirection Either \dQuote{Ascending} or \dQuote{Descending}.
#' Ignored if \code{return.all=TRUE}. Most users can ignore this.
#' @param verbose Optionally print the results of the API request to the
#' standard output. Default is taken from \code{getOption('MTurkR.verbose',
#' TRUE)}.
#' @param ... Additional arguments passed to \code{\link{request}}.
#' @return A data frame containing only a column of HITIds.
#' @author Thomas J. Leeper
#' @seealso \code{\link{GetHIT}}
#' 
#' \code{\link{GetHITsForQualificationType}}
#' 
#' \code{\link{SearchHITs}}
#' @references
#' \href{http://docs.amazonwebservices.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_GetReviewableHITsOperation.htmlAPI
#' Reference}
#' @keywords HITs
#' @examples
#' 
#' \dontrun{
#' GetReviewableHITs()
#' }
#' 