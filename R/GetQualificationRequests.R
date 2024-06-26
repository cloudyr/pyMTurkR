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
#' \code{qualrequests()} and \code{ListQualificationRequests()} are aliases.
#'
#' @aliases GetQualificationRequests ListQualificationRequests qualrequests
#' @param qual An optional character string containing a QualificationTypeId to
#' which the search should be restricted. If none is supplied, requests made
#' for all QualificationTypes are returned.
#' @param pagetoken An optional character string indicating which page of
#' search results to start at. Most users can ignore this.
#' @param results An optional character string indicating how many results to
#' fetch per page. Must be between 1 and 100. Most users can ignore this.
#' @param verbose Optionally print the results of the API request to the
#' standard output. Default is taken from \code{getOption('pyMTurkR.verbose',
#' TRUE)}.
#' @return A data frame containing the QualificationRequestId, WorkerId, and
#' other information (e.g., Qualification Test results) for each request.
#' @author Tyler Burleigh, Thomas J. Leeper
#' @seealso \code{\link{GrantQualification}}
#'
#' \code{\link{RejectQualification}}
#' @references
#' \href{https://docs.aws.amazon.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_ListQualificationRequestsOperation.html}{API Reference}
#' @keywords Qualifications
#' @examples
#'
#' \dontrun{
#' GetQualificationRequests()
#'
#' # Search for qualifications you own, then get requests for one of the quals
#' SearchQualificationTypes(must.be.owner = TRUE, verbose = FALSE) -> quals
#' quals$QualificationTypeId[[1]] -> qual1
#' GetQualificationRequests(qual1)
#' }
#'
#' @export GetQualificationRequests
#' @export ListQualificationRequests
#' @export qualrequests

GetQualificationRequests <-
  ListQualificationRequests <-
  qualrequests <-
  function (qual = NULL,
            results = as.integer(100),
            pagetoken = NULL,
            verbose = getOption('pyMTurkR.verbose', TRUE)) {

    GetClient() # Boto3 client

    if(!is.null(qual)){
      SearchQualificationTypes(must.be.owner = TRUE, verbose = FALSE) -> quals
      if(!qual %in% quals$QualificationTypeId){
        stop("Can only get Qualification Requests for Qualifications you own")
      }
    }

    batch <- function(pagetoken = NULL) {

      # Use page token if given
      if(!is.null(pagetoken)){
        if(is.null(qual)){
          response <- try(pyMTurkR$Client$list_qualification_requests(NextToken = pagetoken,
                                                             MaxResults = as.integer(results)), silent = !verbose)
        } else {
          response <- try(pyMTurkR$Client$list_qualification_requests(QualificationTypeId = qual,
                                                             NextToken = pagetoken,
                                                             MaxResults = as.integer(results)), silent = !verbose)
        }
      } else {
        if(is.null(qual)){
          response <- try(pyMTurkR$Client$list_qualification_requests(MaxResults = as.integer(results)), silent = !verbose)
        } else {
          response <- try(pyMTurkR$Client$list_qualification_requests(QualificationTypeId = qual,
                                                             MaxResults = as.integer(results)), silent = !verbose)

        }
      }

      # Validity check response
      if (inherits(response, "try-error")) {
        stop("Request failed")
      }

      response$QualificationRequests <- ToDataFrameQualificationRequests(response$QualificationRequests)
      return(response)
    }

    # Fetch first page
    response <- batch()
    results.found <- response$NumResults
    to.return <- response

    if (!is.null(response$NextToken)) { # continue to fetch pages

      # Starting with the next page, identified using NextToken
      pagetoken <- response$NextToken

      # Fetch while the number of results is equal to max results per page
      while (results.found == results) {

        # Fetch next batch
        response <- batch(pagetoken)

        # Add to HIT DF
        to.return$QualificationRequests <- rbind(to.return$QualificationRequests,
                                                 response$QualificationRequests)

        results.found <- response$NumResults

        # Update page token
        if(!is.null(response$NextToken)){
          pagetoken <- response$NextToken
        }
      }
    }

    if (verbose) {
      message(nrow(to.return$QualificationRequests), " Requests Retrieved")
    }
    return(to.return$QualificationRequests)
  }
