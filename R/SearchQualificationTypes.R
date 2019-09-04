#' Search Qualification Types
#'
#' Search for Qualification Types.
#'
#' This function will search Qualification Types. It can search through the
#' Qualifications you created, or through all the Qualifications that exist.
#'
#' \code{SearchQuals()}, \code{searchquals()},\code{ListQualificationTypes()}
#' \code{listquals()}, \code{ListQuals()} are aliases
#'
#' @aliases SearchQualificationTypes SearchQualifications SearchQuals searchquals
#' ListQualificationTypes listquals ListQuals
#' @param search.query An optional character string to use as a search query
#' @param must.be.requestable A boolean indicating whether the Qualification
#' must be requestable by Workers or not.
#' @param must.be.owner A boolean indicating whether to search only the
#' Qualifications you own / created, or to search all Qualifications.
#' Defaults to FALSE.
#' @param return.pages An integer indicating how many pages of results should
#' be returned.
#' @param pagetoken An optional character string indicating which page of
#' search results to start at. Most users can ignore this.
#' @param results An optional character string indicating how many results to
#' fetch per page. Must be between 1 and 100. Most users can ignore this.
#' @param verbose Optionally print the results of the API request to the
#' standard output. Default is taken from \code{getOption('pyMTurkR.verbose',
#' TRUE)}.
#' @return A data frame of Qualification Types
#' @author Tyler Burleigh
#' @references
#' \href{https://docs.aws.amazon.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_ListQualificationTypesOperation.html}{API Reference}
#' @keywords HITs
#' @examples
#'
#' \dontrun{
#' SearchQuals()
#' }
#'
#' @export SearchQualificationTypes
#' @export SearchQualifications
#' @export SearchQuals
#' @export searchquals
#' @export ListQualificationTypes
#' @export listquals
#' @export ListQuals

SearchQualificationTypes <-
  SearchQualifications <-
  SearchQuals <-
  searchquals <-
  ListQualificationTypes <-
  listquals <-
  ListQuals <-
  function (search.query = NULL, must.be.requestable = FALSE,
            must.be.owner = FALSE, results = as.integer(100),
            return.pages = NULL, pagetoken = NULL,
            verbose = getOption('pyMTurkR.verbose', TRUE)) {

    GetClient() # Boto3 client

    if(must.be.owner == FALSE){
      message("Searching all Qualifications that exist. Limiting results to 1 page.")
      return.pages <- 1
    }

    batch <- function(pagetoken = NULL) {

      # List to store arguments
      args <- list()

      # Set the function to use later
      fun <- .pyMTurkRClient$list_qualification_types

      # Add required arguments
      args <- c(args, list(MustBeRequestable = as.logical(must.be.requestable),
                           MustBeOwnedByCaller = as.logical(must.be.owner),
                           MaxResults = as.integer(results)))

      if(!is.null(search.query)){
        args <- c(args, list(Query = search.query))
      }
      if(!is.null(pagetoken)){
        args <- c(args, list(NextToken = pagetoken))
      }

      # Execute the API call
      response <- try(
        do.call('fun', args), silent = !verbose
      )

      # Validity check response
      if(class(response) == "try-error") {
        stop("Request failed!")
      }

      quals <- ToDataFrameQualificationTypes(response$QualificationTypes)
      token <- response$NextToken
      results <- response$NumResults
      return(list(Quals = quals, NextToken = token, NumResults = results))
    }


    # Fetch first page
    response <- batch()
    results.found <- response$NumResults
    to.return <- response$Quals

    pages <- 1

    if (!is.null(response$NextToken)) { # continue to fetch pages

      # Starting with the next page, identified using NextToken
      pagetoken <- response$NextToken

      # Fetch while the number of results is equal to max results per page
      while (results.found == results &
             (is.null(return.pages) || pages < return.pages)) {

        # Fetch next batch
        response <- batch(pagetoken)

        # Add to DF
        to.return <- rbind(to.return, response$Quals)

        results.found <- response$NumResults

        # Update page token
        if(!is.null(response$NextToken)){
          pagetoken <- response$NextToken
        }
        pages <- pages + 1
      }
    }

    if (verbose) {
      message(nrow(to.return), " Qualification Types Retrieved")
    }
    return(to.return)
  }
