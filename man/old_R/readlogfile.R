#' Read the MTurkR Logfile
#' 
#' A log of all MTurk API requests are stored in a tab-separated value file
#' called \sQuote{MTurkRLog.tsv} in, by default, the current working directory.
#' This function reads this MTurkR logfile into R as a data frame, using
#' \code{read.delim}.
#' 
#' By default, MTurkR stores a record of all MTurk API requests in a local file
#' in the working directory (though this can be reset with
#' \code{options('MTurkR.logdir')}. This function reads the locally stored
#' MTurkR log file (\file{MTurkRlog.tsv}) into R as a data frame. This is
#' useful for error checking and reviewing prior requests.
#' 
#' @param path An optional character string specifying the path of a directory
#' containing an MTurkR log file.
#' @param filename The name of the MTurkR log file. The default is
#' \file{MTurkRlog.tsv}.
#' @return A data frame containing details of previous (logged) MTurk API
#' requests (including RequestId, Operation performed, REST query parameters,
#' and MTurk response XML as a character string).
#' @author Thomas J. Leeper
#' @seealso \code{\link{request}}
#' @keywords IO
#' @examples
#' 
#' \dontrun{
#' log <- readlogfile()
#' }
#' 