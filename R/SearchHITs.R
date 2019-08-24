#' Search your HITs
#'
#' Search for your HITs and return those HITs as R objects.
#'
#' Retrieve your current HITs (and, optionally, characteristics thereof).
#'
#' \code{searchhits()}, \code{ListHITs()}, and \code{listhits()} are aliases
#'
#' @aliases SearchHITs searchhits ListHITs listhits
#' @param return.pages An integer indicating how many pages of results should
#' be returned.
#' @param pagetoken An optional character string indicating which page of
#' search results to start at. Most users can ignore this.
#' @param results An optional character string indicating how many results to
#' fetch per page. Must be between 1 and 100. Most users can ignore this.
#' @param verbose Optionally print the results of the API request to the
#' standard output. Default is taken from \code{getOption('pyMTurkR.verbose',
#' TRUE)}.
#' @return A list containing data frames of HITs and Qualification Requirements
#' @author Tyler Burleigh, Thomas J. Leeper
#' @references
#' \href{https://docs.aws.amazon.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_ListHITsOperation.html}{API
#' Reference}
#' @keywords HITs
#' @examples
#'
#' \dontrun{
#' SearchHITs()
#' }
#'
#' @export SearchHITs
#' @export searchhits
#' @export ListHITs
#' @export listhits

SearchHITs <-
searchhits <-
ListHITs <-
listhits <-
function (return.pages = NULL,
          results = as.integer(100),
          pagetoken = NULL,
          verbose = getOption('pyMTurkR.verbose', TRUE)) {

  client <- GetClient() # Boto3 client

  batch <- function(pagetoken = NULL) {

    # Use page token if given
    if(!is.null(pagetoken)){
      response <- try(client$list_hits(NextToken = pagetoken, MaxResults = as.integer(results)))
    } else {
      response <- try(client$list_hits(MaxResults = as.integer(results)))
    }

    # Validity check response
    if(class(response) == "try-error") {
      stop("SearchHITs() request failed!")
    }

    response$QualificationRequirements <- ToDataFrameQualificationRequirements(response$HITs)
    response$HITs <- ToDataFrameHITs(response$HITs)
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
          to.return$HITs <- rbind(to.return$HITs, response$HITs)

          to.return$QualificationRequirements <- rbind(to.return$QualificationRequirements,
                                                       response$QualificationRequirements)

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
  return(to.return[c("HITs", "QualificationRequirements")])
}
