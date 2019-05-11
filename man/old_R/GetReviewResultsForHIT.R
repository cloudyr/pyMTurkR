#' Get ReviewPolicy Results for a HIT
#' 
#' Get HIT- and/or Assignment-level ReviewPolicy Results for a HIT
#' 
#' A simple function to return the results of a ReviewPolicy. This is intended
#' only for advanced users, who should reference MTurk documentation for
#' further information or see the notes in
#' \code{\link{GenerateHITReviewPolicy}}.
#' 
#' \code{reviewresults} is an alias.
#' 
#' @aliases GetReviewResultsForHIT reviewresults
#' @param hit A character string containing a HITId.
#' @param assignment An optional character string containing an AssignmentId.
#' If specified, only results pertaining to that assignment will be returned.
#' @param policy.level Either \code{HIT} or \code{Assignment}. If \code{NULL}
#' (the default), all data for both policy levels is retrieved.
#' @param retrieve.results Optionally retrieve ReviewResults. Default is
#' \code{TRUE}.
#' @param retrieve.actions Optionally retrieve ReviewActions. Default is
#' \code{TRUE}.
#' @param return.all A logical indicating whether all Qualifications (as
#' opposed to a specified page of the search results) should be returned.
#' Default is \code{FALSE}.
#' @param pagenumber An optional character string indicating which page of
#' search results should be returned. Most users can ignore this.
#' @param pagesize An optional character string indicating how many search
#' results should be returned by each request, between 1 and 400. Most users
#' can ignore this.
#' @param verbose Optionally print the results of the API request to the
#' standard output. Default is taken from \code{getOption('MTurkR.verbose',
#' TRUE)}.
#' @param ... Additional arguments passed to \code{\link{request}}.
#' @return A four-element list containing up to four named data frames,
#' depending on what ReviewPolicy (or ReviewPolicies) were attached to the HIT
#' and whether results or actions are requested: \code{AssignmentReviewResult},
#' \code{AssignmentReviewAction}, \code{HITReviewResult}, and/or
#' \code{HITReviewAction}.
#' @author Thomas J. Leeper
#' @seealso \code{\link{CreateHIT}}
#' 
#' \code{\link{GenerateHITReviewPolicy}}
#' @references
#' \href{http://docs.amazonwebservices.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_GetReviewResultsForHitOperation.htmlAPI
#' Reference}
#' 
#' \href{http://docs.amazonwebservices.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_ReviewPoliciesArticle.htmlAPI
#' Reference (ReviewPolicies)}
#' 
#' \href{http://docs.amazonwebservices.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_HITReviewPolicyDataStructureArticle.htmlAPI
#' Reference (Data Structure)}
#' @keywords HITs