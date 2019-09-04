#' Set HIT as \dQuote{Reviewing}
#'
#' Update the review status of a HIT, from \dQuote{Reviewable} to
#' \dQuote{Reviewing} or the reverse.
#'
#' A function to change the status of one or more HITs (or all HITs of a given
#' HITType) to \dQuote{Reviewing} or the reverse. This affects what HITs are
#' returned by \code{\link{GetReviewableHITs}}. Must specify a HITId xor a
#' HITTypeId xor an annotation.
#'
#' \code{reviewing()} and \code{UpdateHITReviewStatus()} are aliases.
#'
#' @aliases SetHITAsReviewing reviewing UpdateHITReviewStatus
#' @param hit An optional character string containing a HITId, or a vector
#' character strings containing HITIds, whose status are to be changed. Must
#' specify \code{hit} xor \code{hit.type} xor \code{annotation}.
#' @param hit.type An optional character string specifying a HITTypeId (or a
#' vector of HITTypeIds), all the HITs of which should be set as
#' \dQuote{Reviewing} (or the reverse). Must specify \code{hit} xor
#' \code{hit.type} xor \code{annotation}.
#' @param annotation An optional character string specifying the value of the
#' \code{RequesterAnnotation} field for a batch of HITs. This can be used to
#' set the review status all HITs from a \dQuote{batch} created in the online
#' Requester User Interface (RUI). To use a batch ID, the batch must be written
#' in a character string of the form \dQuote{BatchId:78382;}, where
#' \dQuote{73832} is the batch ID shown in the RUI. Must specify \code{hit} xor
#' \code{hit.type} xor \code{annotation}.
#' @param revert An optional logical to revert the HIT from \dQuote{Reviewing}
#' to \dQuote{Reviewable}.
#' @param verbose Optionally print the results of the API request to the
#' standard output. Default is taken from \code{getOption('pyMTurkR.verbose',
#' TRUE)}.
#' @return A data frame containing HITId, status, and whether the request to
#' change the status of each was valid.
#' @author Tyler Burleigh, Thomas J. Leeper
#' @seealso \code{\link{GetReviewableHITs}}
#' @references
#' \href{https://docs.aws.amazon.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_UpdateHITReviewStatusOperation.html}{API Reference}
#' @keywords HITs
#' @examples
#'
#' \dontrun{
#'
#' a <- GenerateExternalQuestion("https://www.example.com/", "400")
#' hit1 <- CreateHIT(hit.type = "2FFNCWYB49F9BBJWA4SJUNST5OFSOW",
#'                   question = a$string,
#'                   expiration = seconds(hours = 1))
#' SetHITAsReviewing(hit1$HITId)
#'
#' # cleanup
#' DisableHIT(hit1$HITId)
#'
#' }
#'
#' @export SetHITAsReviewing
#' @export reviewing
#' @export UpdateHITReviewStatus

SetHITAsReviewing <-
  reviewing <-
  UpdateHITReviewStatus <-
  function(hit = NULL,
           hit.type = NULL,
           annotation = NULL,
           revert = FALSE,
           verbose = getOption('pyMTurkR.verbose', TRUE)){

    GetClient() # Boto3 client

    if(is.na(as.logical(revert))){
      stop("Revert parameter must be TRUE or FALSE")
    } else {
      revert <- as.logical(revert)
    }

    # Validate hit, hit.type. annotation parameters -- must have one
    if (all(is.null(hit), is.null(hit.type), is.null(annotation))) {
      stop("Must provide 'hit' xor 'hit.type' xor 'annotation'")
    } else if (!is.null(hit)) {
      hitlist <- as.character(hit)

    } else if (!is.null(hit.type)) {
      if (is.factor(hit.type)) {
        hit.type <- as.character(hit.type)
      }
      hitsearch <- SearchHITs()
      hitlist <- hitsearch$HITs$HITId[hitsearch$HITs$HITTypeId %in% hit.type]

    } else if (!is.null(annotation)) {
      if (is.factor(annotation)) {
        annotation <- as.character(annotation)
      }
      hitsearch <- SearchHITs(verbose = FALSE)
      hitlist <- hitsearch$HITs$HITId[grepl(annotation, hitsearch$HITs$RequesterAnnotation)]
    }
    if (length(hitlist) == 0 || is.null(hitlist)) {
      stop("No HITs found for HITType")
    }

    HITs <- emptydf(length(hitlist), 3, c("HITId", "Status", "Valid"))

    for (i in 1:length(hitlist)) {

      hit <- hitlist[i]

      response <- try(pyMTurkRClient$update_hit_review_status(
        HITId = hit,
        Revert = revert
      ), silent = !verbose)

      if (revert == FALSE) {
        status <- "Reviewing"
      } else if (revert == TRUE) {
        status <- "Reviewable"
      }

      if(class(response) == "try-error") {
        warning(i, ": Invalid Request for HIT ", hit)
        valid = FALSE
      } else {

        if(verbose){
          if (revert == FALSE) {
            message(i, ": HIT (", hit, ") set as Reviewing")
          }
          if (revert == TRUE) {
            message(i, ": HIT (", hit, ") set as Reviewable")
          }
        }
        valid = TRUE
      }
      HITs[i, ] <- c(hit, status, valid)
    }
    return(HITs)
  }
