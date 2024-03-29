% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/AccountBalance.R
\name{AccountBalance}
\alias{AccountBalance}
\alias{accountbalance}
\alias{getbalance}
\alias{get_account_balance}
\title{Retrieve MTurk account balance}
\usage{
AccountBalance()
}
\value{
Returns a list of length 2: \dQuote{AvailableBalance}, the balance of
the account in US Dollars, and \dQuote{RequestMetadata}, the metadata for the
request. Note: list is returned invisibly.
}
\description{
Retrieves the amount of money (in US Dollars) in your MTurk account.
}
\details{
\code{AccountBalance} takes no arguments.

\code{accountbalance()}, \code{get_account_balance()} and \code{getbalance()}
are aliases for \code{AccountBalance}.
}
\examples{

\dontrun{
AccountBalance()
}

}
\references{
\href{https://docs.aws.amazon.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_GetAccountBalanceOperation.html}{API
Reference}

\href{https://requester.mturk.com/pricing}{MTurk Pricing Structure}
}
\author{
Tyler Burleigh, Thomas J. Leeper
}
