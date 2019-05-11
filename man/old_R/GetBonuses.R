#' Get Bonus Payments
#' 
#' Get details of bonuses paid to workers, by HIT, HITType, or Assignment.
#' 
#' Retrieve bonuses previously paid to a specified HIT, Assignment, or HITType.
#' 
#' \code{bonuses()} is an alias.
#' 
#' @aliases GetBonuses bonuses
#' @param assignment An optional character string containing an AssignmentId
#' whose bonuses should be returned. Must specify \code{assignment} xor
#' \code{hit} xor \code{hit.type} xor \code{annotation}.
#' @param hit An optional character string containing a HITId whose bonuses
#' should be returned. Must specify \code{assignment} xor \code{hit} xor
#' \code{hit.type} xor \code{annotation}.
#' @param hit.type An optional character string containing a HITTypeId (or a
#' vector of HITTypeIds) whose bonuses should be returned. Must specify
#' \code{assignment} xor \code{hit} xor \code{hit.type} xor \code{annotation}.
#' @param annotation An optional character string specifying the value of the
#' \code{RequesterAnnotation} field for a batch of HITs. This can be used to
#' retrieve bonuses for all HITs from a \dQuote{batch} created in the online
#' Requester User Interface (RUI). To use a batch ID, the batch must be written
#' in a character string of the form \dQuote{BatchId:78382;}, where
#' \dQuote{73832} is the batch ID shown in the RUI. Must specify
#' \code{assignment} xor \code{hit} xor \code{hit.type} xor \code{annotation}.
#' @param return.all A logical indicating whether all HITs (as opposed to a
#' specified page of the search results) should be returned. Default is
#' \code{TRUE}. Note: This is (temporarily) ignored.
#' @param pagenumber An optional character string indicating which page of
#' search results should be returned. Most users can ignore this.
#' @param pagesize An optional character string indicating how many search
#' results should be returned by each request, between 1 and 100. Most users
#' can ignore this.
#' @param verbose Optionally print the results of the API request to the
#' standard output. Default is taken from \code{getOption('MTurkR.verbose',
#' TRUE)}.
#' @param ... Additional arguments passed to \code{\link{request}}.
#' @return A data frame containing the details of each bonus, specifically:
#' AssignmentId, WorkerId, Amount, CurrencyCode, FormattedPrice, Reason, and
#' GrantTime.
#' @author Thomas J. Leeper
#' @seealso \code{\link{GrantBonus}}
#' @references
#' \href{http://docs.amazonwebservices.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_GetBonusPaymentsOperation.htmlAPI
#' Reference}
#' @keywords Workers
#' @examples
#' 
#' \dontrun{
#' # Get bonuses for a given assignment
#' GetBonuses(assignment = "26XXH0JPPSI23H54YVG7BKLO82DHNU")
#' 
#' # Get all bonuses for a given HIT
#' GetBonuses(hit = "2MQB727M0IGF304GJ16S1F4VE3AYDQ")
#' 
#' # Get bonuses from all HITs of a given batch from the RUI
#' GetBonuses(annotation="BatchId:78382;")
#' }
#' 