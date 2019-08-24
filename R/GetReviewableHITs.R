#' Get Reviewable HITs
#'
#' Get HITs that are currently reviewable.
#'
#' A simple function to return the HITIds of HITs currently in
#' \dQuote{Reviewable} or \dQuote{Reviewing} status. To retrieve additional
#' details about each of these HITs, see \code{\link{GetHIT}}. This is an
#' alternative to \code{\link{SearchHITs}}.
#'
#' \code{reviewable()} is an alias.
#'
#' @aliases GetReviewableHITs reviewable
#' @param hit.type An optional character string containing a HITTypeId to
#' consider when looking for reviewable HITs.
#' @param status An optional character string of either \dQuote{Reviewable} or
#' \dQuote{Reviewing} limiting the search to HITs of with either status.
#' @param return.pages An integer indicating how many pages of results should
#' be returned.
#' @param pagetoken An optional character string indicating which page of
#' search results to start at. Most users can ignore this.
#' @param results An optional character string indicating how many results to
#' fetch per page. Must be between 1 and 100. Most users can ignore this.
#' @param verbose Optionally print the results of the API request to the
#' standard output. Default is taken from \code{getOption('pyMTurkR.verbose',
#' TRUE)}.
#' @return A data frame containing HITIds and Requester Annotations.
#' @author Tyler Burleigh, Thomas J. Leeper
#' @references
#' \href{http://docs.amazonwebservices.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_GetReviewableHITsOperation.html}{API Reference}
#' @keywords HITs
#' @examples
#'
#' \dontrun{
#' GetReviewableHITs()
#' }
#'
#' @export

GetReviewableHITs <-
  reviewable <-
  function(hit.type = NULL,
            status = "Reviewable",
            return.pages = NULL,
            results = as.integer(100),
            pagetoken = NULL,
            verbose = getOption('pyMTurkR.verbose', TRUE)) {

    client <- GetClient() # Boto3 client

    if (is.factor(hit.type)) {
      hit.type <- as.character(hit.type)
    }

    batch <- function(pagetoken = NULL) {

      # List to store arguments
      args <- list()

      # Set the function to use later
      fun <- client$list_reviewable_hits

      # Add required arguments
      args <- c(args, list(Status = status,
                           MaxResults = as.integer(results)))

      if(!is.null(pagetoken)) {
        args <- c(args, list(NextToken = pagetoken))
      }
      if(!is.null(hit.type)) {
        args <- c(args, list(HITTypeId = hit.type))
      }

      # Execute the API call
      response <- try(
        do.call('fun', args)
      )

      # Validity check response
      if(class(response) == "try-error") {
        stop("Request failed")
      }

      if(length(response$HITs) > 0){
        response <- ToDataFrameReviewableHITs(response$HITs)
        return(response)
      } else {
        stop("No HITs found")
      }
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
        to.return <- rbind(to.return, response)

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
      message(runningtotal, " HITs Retrieved")
    }
    return(to.return)
  }
