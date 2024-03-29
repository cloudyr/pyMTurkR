#' Retrieve MTurk account balance
#'
#' Retrieves the amount of money (in US Dollars) in your MTurk account.
#'
#' \code{AccountBalance} takes no arguments.
#'
#' \code{accountbalance()}, \code{get_account_balance()} and \code{getbalance()}
#' are aliases for \code{AccountBalance}.
#'
#' @aliases AccountBalance accountbalance getbalance get_account_balance
#' @return Returns a list of length 2: \dQuote{AvailableBalance}, the balance of
#' the account in US Dollars, and \dQuote{RequestMetadata}, the metadata for the
#' request. Note: list is returned invisibly.
#' @author Tyler Burleigh, Thomas J. Leeper
#' @references
#' \href{https://docs.aws.amazon.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_GetAccountBalanceOperation.html}{API
#' Reference}
#'
#' \href{https://requester.mturk.com/pricing}{MTurk Pricing Structure}
#' @examples
#'
#' \dontrun{
#' AccountBalance()
#' }
#'
#' @export AccountBalance
#' @export accountbalance
#' @export getbalance

AccountBalance <-
accountbalance <-
getbalance <-
function() {
  GetClient() # Boto3 client
  result <- pyMTurkR$Client$get_account_balance()
  message(paste("Balance: $", result$AvailableBalance, "\n", sep = ""))
  return(result$AvailableBalance)
}
