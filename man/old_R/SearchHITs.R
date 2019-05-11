#' Search your HITs
#' 
#' Search for your HITs and return those HITs as R objects.
#' 
#' Retrieve your current HITs (and, optionally, characteristics thereof). To
#' view HITs on the MTurk requester website, see
#' \code{\link{OpenManageHITPage}}. To view HITs on the MTurk worker website,
#' use \code{\link{ViewAvailableHITs}}.
#' 
#' \code{searchhits()} is an alias.
#' 
#' @aliases SearchHITs searchhits
#' @param response.group An optional character string (or vector of character
#' strings) specifying what details of each HIT to return of: \dQuote{Request},
#' \dQuote{Minimal}, \dQuote{HITDetail}, \dQuote{HITQuestion},
#' \dQuote{HITAssignmentSummary}. For more information, see
#' \href{http://docs.aws.amazon.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_CommonParametersArticle.htmlCommon
#' Parameters} and
#' \href{http://docs.amazonwebservices.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_HITDataStructureArticle.htmlHIT
#' Data Structure}.
#' @param return.all A logical indicating whether all HITs (as opposed to a
#' specified page of the search results) should be returned. Default is
#' \code{TRUE}.
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
#' @param return.hit.dataframe A logical indicating whether the data frame of
#' HITs should be returned. Default is \code{TRUE}.
#' @param return.qual.dataframe A logical indicating whether the list of each
#' HIT's QualificationRequirements (stored as data frames in that list) should
#' be returned. Default is \code{TRUE}.
#' @param verbose Optionally print the results of the API request to the
#' standard output. Default is taken from \code{getOption('MTurkR.verbose',
#' TRUE)}.
#' @param ... Additional arguments passed to \code{\link{request}}.
#' @return A list one- or two-element list containing a data frame of HIT
#' details and, optionally (if `return.qual.dataframe = TRUE`), a list of each
#' HIT's QualificationRequirements (stored as data frames in that list).
#' @author Thomas J. Leeper
#' @seealso \code{\link{GetHIT}}
#' 
#' \code{\link{GetReviewableHITs}}
#' 
#' \code{\link{SearchQualificationTypes}}
#' 
#' \code{\link{ViewAvailableHITs}}
#' @references
#' \href{http://docs.amazonwebservices.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_SearchHITsOperation.htmlAPI
#' Reference}
#' @keywords HITs
#' @examples
#' 
#' \dontrun{
#' SearchHITs()
#' }
#' 