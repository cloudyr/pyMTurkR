#' Search your HITs
#'
#' Search for your HITs and return those HITs as R objects.
#'
#' Retrieve your current HITs (and, optionally, characteristics thereof).
#'
#' \code{searchhits()}, \code{ListHITs()}, and \code{listhits()} are aliases
#'
#' @aliases SearchHITs searchhits ListHITs listhits
#' @param return.all A logical indicating whether all HITs (as opposed to a
#' small subjset) should be returned. Default is \code{TRUE}.
#' @param pagetoken An optional character string indicating which page of
#' search results should be returned. Most users can ignore this.
#' @param results An optional character string indicating how many search
#' results should be returned by each request, between 1 and 100. Most users
#' can ignore this.
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

SearchHITs <-
searchhits <-
ListHITs <-
listhits <-
function (return.all = TRUE, results = as.integer(10),
          pagetoken = NULL, sandbox = TRUE,
          profile = 'default', verbose = TRUE) {

  client <- GetClient(sandbox, profile) # Boto3 client

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

    response$QualificationRequirements <- as.data.frame.QualificationRequirements(response$HITs)
    response$HITs <- as.data.frame.HITs(response$HITs)
    return(response)
  }


  # Fetch first page
  response <- batch()
  results.found <- response$NumResults
  to.return <- response

  # Keep a running total of all HITs returned
  runningtotal <- response$NumResults
  pages <- 1

  if (return.all & !is.null(response$NextToken)) { # If user wants all results
                    # continue to fetch pages

      # Starting with the next page, identified using NextToken
      pagetoken <- response$NextToken

      # Fetch while the number of results is equal to max results per page
      while (results.found == results) {

          # Fetch next batch
          response <- batch(pagetoken)

          # If user wants HIT df, add to that
          to.return$HITs <- rbind(to.return$HITs, response$HITs)

          to.return$QualificationRequirements <- rbind(to.return$QualificationRequirements,
                                                       response$QualificationRequirements)

          # Add to running total
          runningtotal <- runningtotal + response$NumResults
          results.found <- response$NumResults

          # Update page token
          pagetoken <- response$NextToken
          pages <- pages + 1
      }
  }

  if (verbose) {
    message(runningtotal, " HITs Retrieved")
  }
  return(x[c("HITs", "QualificationRequirements")])
}
