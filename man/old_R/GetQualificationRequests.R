#' Get Qualification Requests
#' 
#' Retrieve workers' requests for a QualificationType.
#' 
#' A function to retrieve pending Qualification Requests made by workers,
#' either for a specified QualificationType or all QualificationTypes.
#' Specifically, all active, custom QualificationTypes are visible to workers,
#' and workers can request a QualificationType (e.g., when a HIT requires one
#' they do not have). This function retrieves those requests so that they can
#' be granted (with \code{\link{GrantQualification}}) or rejected (with
#' \code{\link{RejectQualification}}).
#' 
#' \code{qualrequests()} is an alias.
#' 
#' @aliases GetQualificationRequests qualrequests
#' @param qual An optional character string containing a QualificationTypeId to
#' which the search should be restricted. If none is supplied, requests made
#' for all QualificationTypes are returned.
#' @param return.all A logical indicating whether all QualificationRequestss
#' (as opposed to a specified page of the search results) should be returned.
#' Default is \code{TRUE}.
#' @param pagenumber An optional character string indicating which page of
#' search results should be returned. Most users can ignore this.
#' @param pagesize An optional character string indicating how many search
#' results should be returned by each request, between 1 and 100. Most users
#' can ignore this.
#' @param sortproperty Either \dQuote{SubmitTime} or
#' \dQuote{QualificationTypeId}. Ignored if \code{return.all=TRUE}. Most users
#' can ignore this.
#' @param sortdirection Either \dQuote{Ascending} or \dQuote{Descending}.
#' Ignored if \code{return.all=TRUE}. Most users can ignore this.
#' @param return.qual.dataframe A logical indicating whether the
#' QualificationTypes should be returned as a data frame. Default is
#' \code{TRUE}.
#' @param verbose Optionally print the results of the API request to the
#' standard output. Default is taken from \code{getOption('MTurkR.verbose',
#' TRUE)}.
#' @param ... Additional arguments passed to \code{\link{request}}.
#' @return A data frame containing the QualificationRequestId, WorkerId, and
#' other information (e.g., Qualification Test results) for each request.
#' @author Thomas J. Leeper
#' @seealso \code{\link{GrantQualification}}
#' 
#' \code{\link{RejectQualification}}
#' @references
#' \href{http://docs.amazonwebservices.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_GetQualificationRequestsOperation.htmlAPI
#' Reference}
#' @keywords Qualifications
#' @examples
#' 
#' \dontrun{
#' GetQualificationRequests()
#' GetQualificationRequests("2YCIA0RYNJ9262B1D82MPTUEXAMPLE")
#' }
#' 