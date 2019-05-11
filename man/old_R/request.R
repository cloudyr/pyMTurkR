#' Execute an MTurk API Request
#' 
#' This is the workhorse function that makes authenticated HTTP requests to the
#' MTurk API. It is not exported as of v0.5.
#' 
#' This is an internal function that executes MTurk API requests. It is made
#' available for use by advanced users to execute custom API requests.
#' 
#' @aliases request print.MTurkResponse
#' @param operation The MTurk API operation to be performed.
#' @param GETparameters An optional character string containing URL query
#' parameters that specify options for the request.
#' @param keypair A two-element character vector containing an AWS Access Key
#' ID and an AWS Secret Access Key. The easiest way to do this is to specify
#' \samp{AWS_ACCESS_KEY_ID} and \samp{AWS_SECRET_ACCESS_KEY} environment
#' variables using \code{Sys.setenv()} or by placing these values in an
#' .Renviron file.
#' @param browser Optionally open the request in the default web browser,
#' rather than opening in R. Default is \code{FALSE}.
#' @param log.requests A logical specifying whether API requests should be
#' logged. Default is \code{TRUE}. See \code{\link{readlogfile}} for details.
#' The log is stored, by default, in the working directory at the time MTurkR
#' is loaded. This can be changed using \code{options("MTurkR.logdir")}; if not
#' set, the current working directory is used.
#' @param sandbox Optionally execute the request in the MTurk sandbox rather
#' than the live server.  Default is \code{FALSE}.
#' @param verbose Whether errors produced by the MTurk API request should be
#' printed.
#' @param validation.test Currently a logical that causes \code{request} to
#' return the URL of the specified REST request. Default is \code{FALSE}. May
#' additionally validate the request (and supply information about that
#' validation) in the future.
#' @param service The MTurk service to which the authenticated request will be
#' sent. Supplied only for advanced users.
#' @param version The version of the MTurk API to use.
#' @return A list of class \dQuote{MTurkResponse} containing:
#' \item{operation}{A character string identifying the MTurk API operation
#' performed.} \item{request.id}{The Request ID created by the API request.}
#' \item{request.url}{The URL of the MTurk API REST request.} \item{valid}{A
#' logical indicating whether or not the request was valid and thus executed as
#' intended.} \item{xml}{A character string containing the XML API response.}
#' @author Thomas J. Leeper
#' @references
#' \href{http://docs.amazonwebservices.com/AWSMechTurk/latest/AWSMechanicalTurkRequester/MakingRequestsArticle.htmlAPI
#' Reference}