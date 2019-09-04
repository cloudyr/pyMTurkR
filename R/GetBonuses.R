#' Get Bonus Payments
#'
#' Get details of bonuses paid to workers, by HIT, HITType, Assignment,
#' or Annotation.
#'
#' Retrieve bonuses previously paid to a specified HIT, HITType, Assignment,
#' or Annotation.
#'
#' \code{bonuses()}, \code{getbonuses()}, \code{ListBonusPayments()} and
#' \code{listbonuspayments()} are aliases.
#'
#' @aliases GetBonuses getbonuses bonuses ListBonusPayments listbonuspayments
#' @param assignment An optional character string containing an AssignmentId
#' whose bonuses should be returned. Must specify \code{assignment} xor
#' \code{hit} xor \code{hit.type} xor \code{annotation}.
#' @param hit An optional character string containing a HITId whose bonuses
#' should be returned. Must specify \code{assignment} xor \code{hit} xor
#' \code{hit.type} xor \code{annotation}.
#' @param hit.type An optional character string containing a HITTypeId (or a
#' vector of HITTypeIds) whose bonuses should be returned. Must specify
#' \code{assignment} xor \code{hit} xor \code{hit.type} xor \code{annotation}.
#' @param annotation An optional character string specifying the value of the
#' \code{RequesterAnnotation} field for a batch of HITs. This can be used to
#' retrieve bonuses for all HITs from a \dQuote{batch} created in the online
#' Requester User Interface (RUI). To use a batch ID, the batch must be written
#' in a character string of the form \dQuote{BatchId:78382;}, where
#' \dQuote{73832} is the batch ID shown in the RUI. Must specify
#' \code{assignment} xor \code{hit} xor \code{hit.type} xor \code{annotation}.
#' @param pagetoken An optional character string indicating which page of
#' search results to start at. Most users can ignore this.
#' @param results An optional character string indicating how many results to
#' fetch per page. Must be between 1 and 100. Most users can ignore this.
#' @param verbose Optionally print the results of the API request to the
#' standard output. Default is taken from \code{getOption('pyMTurkR.verbose',
#' TRUE)}.
#' @return A data frame containing the details of each bonus, specifically:
#' AssignmentId, WorkerId, Amount, Reason, and GrantTime.
#' @author Tyler Burleigh, Thomas J. Leeper
#' @seealso \code{\link{GrantBonus}}
#' @references
#' \href{https://docs.aws.amazon.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_ListBonusPaymentsOperation.html}{API Reference}
#' @keywords Workers
#' @examples
#'
#' \dontrun{
#' # Get bonuses for a given assignment
#' GetBonuses(assignment = "26XXH0JPPSI23H54YVG7BKLO82DHNU")
#'
#' # Get all bonuses for a given HIT
#' GetBonuses(hit = "2MQB727M0IGF304GJ16S1F4VE3AYDQ")
#'
#' # Get bonuses from all HITs of a given batch from the RUI
#' GetBonuses(annotation = "BatchId:78382;")
#' }
#'
#' @export GetBonuses
#' @export getbonuses
#' @export bonuses
#' @export ListBonusPayments
#' @export listbonuspayments

GetBonuses <-
  ListBonusPayments <-
  getbonuses <-
  bonuses <-
  listbonuspayments <-
  function(assignment = NULL,
           hit = NULL,
           hit.type = NULL,
           annotation = NULL,
           results = as.integer(100),
           pagetoken = NULL,
           verbose = getOption('pyMTurkR.verbose', TRUE)) {

    GetClient() # Boto3 client

    if(sum(!is.null(hit),
           !is.null(hit.type),
           !is.null(annotation),
           !is.null(assignment)) > 1) {
      stop("Too many arguments specified. Must specify hit' OR 'hit.type' OR 'annotation'")
    }

    # Batch process function
    batch <- function(pagetoken = NULL, hit = hit) {

      # Use page token if given
      if(!is.null(pagetoken)){
        response <- try(pyMTurkRClient$list_bonus_payments(HITId = hit,
                                                   NextToken = pagetoken,
                                                   MaxResults = as.integer(results)), silent = !verbose)
      } else {
        response <- try(pyMTurkRClient$list_bonus_payments(HITId = hit,
                                                   MaxResults = as.integer(results)), silent = !verbose)
      }

      # Validity check response
      if(class(response) == "try-error") {
        stop("Request failed")
      }

      if(response$NumResults > 0){
        response$BonusPayments <- ToDataFrameBonusPayments(response$BonusPayments)
        return(response)
      }
    }

    # Batch helper loops through pages
    batch_helper <- function(hit = hit) {

      # Get first batch
      response <- batch(hit = hit)

      results.found <- response$NumResults
      to.return <- response$BonusPayments

      # Get remaining batches
      if (!is.null(response$NextToken)) { # continue to fetch pages

        # Starting with the next page, identified using NextToken
        pagetoken <- response$NextToken

        # Fetch while the number of results is equal to max results per page
        while (results.found == results) {

          # Fetch next batch
          response <- batch(pagetoken = pagetoken, hit = hit)

          # Add to HIT DF
          to.return <- rbind(to.return, response$BonusPayments)
          results.found <- response$NumResults

          # Update page token
          if(!is.null(response$NextToken)){
            pagetoken <- response$NextToken
          }
        }
      }

      return(to.return)

    }

    # Fetch using different input parameters
    # Check that one of the params for lookup was provided
    if (all(is.null(assignment) & is.null(hit) &
            is.null(hit.type) & is.null(annotation))) {
      stop("Must provide 'assignment' xor 'hit' xor 'hit.type' xor 'annotation'")
    } else if(!is.null(hit)){
      to.return <- batch_helper(hit = hit)
    } else if(!is.null(assignment)) {
      response <- try(pyMTurkRClient$list_bonus_payments(AssignmentId = assignment))
      to.return <- ToDataFrameBonusPayments(response$BonusPayments)
    } else if (!is.null(hit.type)) {

      # Check / convert hit.type
      if (is.factor(hit.type)) {
        hit.type <- as.character(hit.type)
      }

      # Get list of hits
      hitsearch <- SearchHITs(verbose = FALSE)
      hitlist <- hitsearch$HITs$HITId[hitsearch$HITs$HITTypeId %in% hit.type]

      if(length(hitlist) == 0){
        stop(paste0("No HITs found for 'hit.type' ", hit.type))
      }

      to.return <- data.frame()

      # Loop over hitlist
      for(i in 1:length(hitlist)){
        hit <- hitlist[i]
        to.return <- rbind(to.return, batch_helper(hit = hit))
      }

    } else if (!is.null(annotation)) {

      # Check / convert annotation
      if (is.factor(annotation)) {
        annotation <- as.character(annotation)
      }
      # Get list of hits
      hitsearch <- SearchHITs(verbose = FALSE)
      hitlist <- hitsearch$HITs$HITId[grepl(annotation, hitsearch$HITs$RequesterAnnotation)]

      if(length(hitlist) == 0){
        stop(paste0("No HITs found for 'annotation' ", annotation))
      }

      to.return <- data.frame()

      # Loop over hitlist
      for(i in 1:length(hitlist)){
        hit <- hitlist[i]
        to.return <- rbind(to.return, batch_helper(hit = hit))
      }

    }

    if (verbose) {
      if(is.null(to.return)){
        results <- 0
        to.return <- emptydf(0, 5, c("AssignmentId", "WorkerId",
                                          "BonusAmount", "Reason",
                                          "GrantTime"))
      } else {
        results <- nrow(to.return)
      }
      message(results, " Worker Bonuses Found")
    }

    return(to.return)

  }
