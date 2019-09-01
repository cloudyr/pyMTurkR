#' Get ReviewPolicy Results for a HIT
#'
#' Get HIT- and/or Assignment-level ReviewPolicy Results for a HIT
#'
#' A simple function to return the results of a ReviewPolicy. This is intended
#' only for advanced users, who should reference MTurk documentation for
#' further information or see the notes in
#' \code{\link{GenerateHITReviewPolicy}}.
#'
#' \code{reviewresults} and \code{ListReviewPolicyResultsForHIT} are aliases.
#'
#' @aliases GetReviewResultsForHIT reviewresults ListReviewPolicyResultsForHIT
#' @param hit A character string containing a HITId.
#' @param policy.level Either \code{HIT} or \code{Assignment}. If \code{NULL}
#' (the default), all data for both policy levels is retrieved.
#' @param return.pages An integer indicating how many pages of results should
#' be returned.
#' @param pagetoken An optional character string indicating which page of
#' search results to start at. Most users can ignore this.
#' @param results An optional character string indicating how many results to
#' fetch per page. Must be between 1 and 100. Most users can ignore this.
#' @param verbose Optionally print the results of the API request to the
#' standard output. Default is taken from \code{getOption('pyMTurkR.verbose',
#' TRUE)}.
#' @return A four-element list containing up to four named data frames,
#' depending on what ReviewPolicy (or ReviewPolicies) were attached to the HIT
#' and whether results or actions are requested: \code{AssignmentReviewResult},
#' \code{AssignmentReviewAction}, \code{HITReviewResult}, and/or
#' \code{HITReviewAction}.
#' @author Tyler Burleigh, Thomas J. Leeper
#' @seealso \code{\link{CreateHIT}}
#'
#' \code{\link{GenerateHITReviewPolicy}}
#' @references
#' \href{https://docs.aws.amazon.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_ListReviewPolicyResultsForHITOperation.html}{API Reference}
#'
#' \href{http://docs.amazonwebservices.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_ReviewPoliciesArticle.html}{API Reference (ReviewPolicies)}
#'
#' \href{http://docs.amazonwebservices.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_HITReviewPolicyDataStructureArticle.html}{API Reference (Data Structure)}
#' @keywords HITs
#' @export

GetReviewResultsForHIT <-
  ListReviewPolicyResultsForHIT <-
  reviewresults <-
  function(hit,
           policy.level = NULL,
           results = as.integer(100),
           pagetoken = NULL,
           verbose = getOption('pyMTurkR.verbose', TRUE)) {

    client <- GetClient() # Boto3 client

    # The function we'll call
    fun <- client$list_review_policy_results_for_hit

    # The arguments we'll call in the function
    args <- list(RetrieveActions = TRUE,
                 RetrieveResults = TRUE)

    if(is.factor(hit)){
      hit <- as.character(hit)
    }
    args <- c(args, HITId = hit)
    if(!is.null(policy.level)) {
      if(!typeof(policy.level) %in% c("character", "list")){
        stop("'policy.level' must be character or list type")
      } else {
        policy.level <- reticulate::tuple(policy.level)
      }
      args <- c(args, PolicyLevels = policy.level)
    }


    batch <- function(pagetoken = NULL) {

      args <- c(args, MaxResults = as.integer(results))

      if(!is.null(pagetoken)) {
        args <- c(args, NextToken = pagetoken)
      }

      # Execute the API call
      response <- try(
        do.call('fun', args)
      )

      # Validity check response
      if(class(response) == "try-error") {
        stop("Request failed")
      }

      if(length(response$AssignmentReviewReport) > 0 | length(response$HITReviewReport) > 0){
        response <- ToDataFrameReviewResults(response)
        return(response)
      } else {
        return(NULL)
      }
    }

    # Fetch first page
    response <- batch()
    to.return <- response

    if (!is.null(response$NextToken)) { # continue to fetch pages

      # Starting with the next page, identified using NextToken
      pagetoken <- response$NextToken

      # Fetch while the number of results is equal to max results per page
      while (!is.null(response)) {

        # Fetch next batch
        response <- batch(pagetoken)

        # Add to HIT DF
        to.return <- rbind(to.return, response)

        # Update page token
        if(!is.null(response$NextToken)){
          pagetoken <- response$NextToken
        }
      }
    }

    if (verbose) {
      message("ReviewResults Retrieved: ", appendLF = FALSE)
      if (is.null(response)) {
        message("0\n")
        to.return <- list(AssignmentReviewResult = NULL,
                          AssignmentReviewAction = NULL,
                          HITReviewResult = NULL,
                          HITReviewAction = NULL)
      } else {
        message("\n")
        message(length(to.return$AssignmentReviewResult), " Assignment ReviewResults Retrieved")
        message(length(to.return$AssignmentReviewAction), " Assignment ReviewActions Retrieved")
        message(length(to.return$HITReviewResult), " HIT ReviewResults Retrieved")
        message(length(to.return$HITReviewAction), " HIT ReviewActions Retrieved")
        message("\n")
      }
    }

    return(to.return)
  }
