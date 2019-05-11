#' MTurk Worker and Requester Statistics
#' 
#' Get a requester statistic or a statistic for a particular worker.
#' \code{RequesterReport} and \code{WorkerReport} provide wrappers that return
#' all available statistics.
#' 
#' Retrieve a specific requester or worker statistic. The list of available
#' statistics can be retrieved by calling \code{\link{ListStatistics}}. Useful
#' for monitoring workers or one's own use of the requester system.
#' 
#' \code{statistic()} is an alias for \code{GetStatistic}.
#' \code{workerstatistic()} is an alias for \code{GetWorkerStatistic}.
#' 
#' @aliases GetStatistic statistic RequesterReport GetWorkerStatistic
#' workerstatistic WorkerReport
#' @param worker A character string containing a WorkerId.
#' @param statistic A character string containing the name of a statistic.
#' Statistics can be retrieved from \code{\link{ListStatistics}}.
#' @param period One of: \dQuote{OneDay}, \dQuote{SevenDays},
#' \dQuote{ThirtyDays}, \dQuote{LifeToDate}. Default is \dQuote{LifeToDate}.
#' @param count If \code{period="OneDay"}, the number of days to return.
#' Default is 1 (the most recent day).
#' @param response.group An optional character string (or vector of character
#' strings) specifying what details to return of \dQuote{Request},
#' \dQuote{Minimal}, or \dQuote{Parameters}. For more information, see
#' \href{http://docs.aws.amazon.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_CommonParametersArticle.htmlCommon
#' Parameters}.
#' @param verbose Optionally print the results of the API request to the
#' standard output. Default is taken from \code{getOption('MTurkR.verbose',
#' TRUE)}.
#' @param ... Additional arguments passed to \code{\link{request}}.
#' @return A data frame containing the Date, Value, and Statistic (and
#' WorkerId, if \code{GetWorkerStatistic} or \code{WorkerReport} are called),
#' and the value thereof. \code{GetStatistic} and \code{GetWorkerStatistic}
#' return only information about the requested statistic as a data.frame.
#' \code{RequesterReport} and \code{WorkerReport} return all of the requester
#' and worker statistics, respectively, that are available in
#' \code{\link{ListStatistics}}.
#' @author Thomas J. Leeper
#' @seealso \code{\link{ListStatistics}}
#' @references
#' \href{http://docs.amazonwebservices.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_GetRequesterStatisticOperation.htmlAPI
#' Reference: Requester Statistics}
#' 
#' \href{http://docs.amazonwebservices.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_GetRequesterWorkerStatisticOperation.htmlAPI
#' Reference: Worker Statistics}
#' @keywords Workers
#' @examples
#' 
#' \dontrun{
#' GetStatistic("NumberHITsCompleted","OneDay")
#' RequesterReport("ThirtyDays")
#' GetWorkerStatistic("A1RO9UJNWXMU65","PercentHITsApproved","LifeToDate")
#' WorkerReport("A1RO9UJNWXMU65","SevenDays")
#' }
#' 