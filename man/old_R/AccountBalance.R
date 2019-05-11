#' Retrieve MTurk account balance
#' 
#' Retrieves the amount of money (in US Dollars) in your MTurk account.
#' \code{SufficientFunds} provides a wrapper that checks whether your account
#' has sufficient funds based upon specified characters of your HIT.
#' 
#' \code{AccountBalance} takes no substantive arguments. \code{SufficientFunds}
#' is a wrapper for \code{AccountBalance} that accepts as inputs information
#' about intended payments and bonuses to check whether your account has
#' sufficient funds. If \code{sandbox=TRUE}, \code{AccountBalance} always
#' returns \dQuote{$10,000.00}.
#' 
#' \code{accountbalance()} and \code{getbalance()} are aliases for
#' \code{AccountBalance}.
#' 
#' @aliases AccountBalance accountbalance getbalance SufficientFunds
#' @param amount Intended per-assignment payment amount.
#' @param assignments Number of intended assignments (per HIT, if multiple
#' HITs).
#' @param hits Number of HITs.
#' @param bonus.ct Number of intended bonuses.
#' @param bonus.amount Amount of each bonus.
#' @param masters A logical indicating whether MTurk Masters will be used.
#' Default is \code{FALSE}.
#' @param turkfee Amazon's fee as percentage of payments. Default is 20-percent
#' (as 0.20). Note, however, that MTurk charges an additional 20-percent if the
#' number of \code{assignments} is greater than or equal to 10. This is
#' factored in automatically
#' @param turkmin Amazon's minimum per-assignment fee. Default is $0.01.
#' @param mastersfee Amazon's additional charge for use of MTurk Masters.
#' Default is 5-percent (as 0.05).
#' @param verbose Optionally print the results of the API request to the
#' standard output. Default is taken from \code{getOption('MTurkR.verbose',
#' TRUE)}.
#' @param ... Additional arguments passed to \code{\link{request}}.
#' @return Return value is an object of class \dQuote{MTurkResponse}, including
#' an additional character string (\code{balance}) containing the balance of
#' the account in US Dollars. Note: object is returned invisibly.
#' @author Thomas J. Leeper
#' @references
#' \href{http://docs.amazonwebservices.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_GetAccountBalanceOperation.htmlAPI
#' Reference}
#' 
#' \href{https://requester.mturk.com/pricingMTurk Pricing Structure}
#' @examples
#' 
#' \dontrun{
#' AccountBalance()
#' SufficientFunds(amount = ".25", assignments = "50", hits = "5")
#' SufficientFunds(bonus.ct = "150", bonus.amount = ".75")
#' }
#' 