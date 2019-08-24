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
#' @param return.pages An integer indicating how many pages of results should
#' be returned.
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
#' GetQualificationRequests("2YCIA0RYNJ9262B1D82MPTUEXAMPLE")
#' }
#'
#' @export

GetQualificationRequests <-
  ListQualificationRequests <-
  qualrequests <-
  function (qual = NULL,
            return.pages = NULL,
            results = as.integer(100),
            pagetoken = NULL,
            verbose = getOption('pyMTurkR.verbose', TRUE)) {

    client <- GetClient() # Boto3 client

    batch <- function(pagetoken = NULL) {

      # Use page token if given
      if(!is.null(pagetoken)){
        if(is.null(qual)){
          response <- try(client$list_qualification_requests(NextToken = pagetoken,
                                                             MaxResults = as.integer(results)))
        } else {
          response <- try(client$list_qualification_requests(QualificationTypeId = qual,
                                                             NextToken = pagetoken,
                                                             MaxResults = as.integer(results)))
        }
      } else {
        if(is.null(qual)){
          response <- try(client$list_qualification_requests(MaxResults = as.integer(results)))
        } else {
          response <- try(client$list_qualification_requests(QualificationTypeId = qual,
                                                             MaxResults = as.integer(results)))

        }
      }

      # Validity check response
      if(class(response) == "try-error") {
        stop("GetQualificationRequests() request failed!")
      }

      response$QualificationRequests <- ToDataFrameQualificationRequests(response$QualificationRequests)
      return(response)
    }

    # Fetch first page
    response <- batch()
    results.found <- response$NumResults
    to.return <- response

    # Keep a running total of all HITs returned
    runningtotal <- response$NumResults
    pages <- 1

    if (!is.null(response$NextToken)) { # continue to fetch pages

      # Starting with the next page, identified using NextToken
      pagetoken <- response$NextToken

      # Fetch while the number of results is equal to max results per page
      while (results.found == results &
             (is.null(return.pages) || pages < return.pages)) {

        # Fetch next batch
        response <- batch(pagetoken)

        # Add to HIT DF
        to.return$QualificationRequests <- rbind(to.return$QualificationRequests, response$QualificationRequests)

        # Add to running total
        runningtotal <- runningtotal + response$NumResults
        results.found <- response$NumResults

        # Update page token
        if(!is.null(response$NextToken)){
          pagetoken <- response$NextToken
        }
        pages <- pages + 1
      }
    }

    if (verbose) {
      message(runningtotal, " Requests Retrieved")
    }
    return(to.return$QualificationRequests)
  }
