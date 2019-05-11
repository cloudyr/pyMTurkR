#' Search QualificationTypes
#' 
#' Search for available QualificationTypes, including yours and others
#' available on the MTurk system created by other requesters.
#' 
#' Retrieve available QualificationTypes, optionally only those
#' QualificationTypes created by you and/or those that meet specific search
#' criteria specified in the \code{query} parameter. Given that the total
#' number of QualificationTypes available from all requesters could be
#' infinitely large, specifying both \code{only.mine=FALSE} and
#' \code{return.all=FALSE} will be time-consuming and may cause memory
#' problems.
#' 
#' \code{searchquals()} is an alias.
#' 
#' @aliases SearchQualificationTypes searchquals
#' @param query An optional character string containing a search query to be
#' used to search among available QualificationTypes.
#' @param only.mine A logical indicating whether only your QualificationTypes
#' should be returned (the default). If \code{FALSE}, QualificationTypes
#' created by all requesters will be returned.
#' @param only.requestable A logical indicating whether only requestable
#' QualificationTypes should be returned. Default is \code{FALSE}.
#' @param return.all A logical indicating whether all QualificationTypes (as
#' opposed to a specified page of the search results) should be returned.
#' Default is \code{TRUE}.
#' @param pagenumber An optional character string indicating which page of
#' search results should be returned. Most users can ignore this.
#' @param pagesize An optional character string indicating how many search
#' results should be returned by each request, between 1 and 100. Most users
#' can ignore this.
#' @param sortproperty API currently only supports \dQuote{Name}. Most users
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
#' @return A data frame containing the QualificationTypeId of the newly created
#' QualificationType and other details as specified in the request.
#' @author Thomas J. Leeper
#' @seealso \code{\link{GetQualificationType}}
#' 
#' \code{\link{CreateQualificationType}}
#' 
#' \code{\link{UpdateQualificationType}}
#' 
#' \code{\link{DisposeQualificationType}}
#' 
#' \code{\link{SearchHITs}}
#' @references
#' \href{http://docs.amazonwebservices.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_SearchQualificationTypesOperation.htmlAPI
#' Reference}
#' @keywords Qualifications
#' @examples
#' 
#' \dontrun{
#' SearchQualificationTypes(only.mine = TRUE, 
#'                          return.all = TRUE)
#' SearchQualificationTypes(query = "MIT", 
#'                          only.mine = FALSE,
#'                          return.all = FALSE)
#' }
#' 