#' Disable/Expire or Delete HIT
#'
#' This function will allow you to expire a HIT early, which means it will no
#' longer be available for new workers to accept. Optionally, when disabling the
#' HIT you can approve all pending assignments and you can also try to delete
#' the HIT.
#'
#' Be careful when deleting a HIT: this will also delete the assignment
#' data! Calling this function with \code{DeleteHIT()}, \code{deletehit()},
#' \code{DisposeHIT()}, or \code{disposehit()} will result in deleting the HIT.
#' The user will be prompted before continuing, unless \code{skip.delete.prompt}
#' is TRUE.
#'
#' If you disable a HIT while workers are still working on an assignment, they
#' will still be able to complete their task.
#'
#' \code{DisposeHIT()}, \code{ExpireHIT()}, \code{DeleteHIT()}, \code{disablehit()},
#' \code{disposehit()}, \code{expirehit()}, \code{deletehit()} are aliases.
#'
#' @aliases DisableHIT DisposeHIT ExpireHIT DeleteHIT disablehit disposehit
#' deletehit
#' @param hit A character string containing a HITId or a vector of character
#' strings containing multiple HITIds. Must specify \code{hit} xor
#' \code{hit.type} xor \code{annotation}.
#' @param hit.type An optional character string containing a HITTypeId (or a
#' vector of HITTypeIds). Must specify \code{hit} xor \code{hit.type} xor
#' \code{annotation}.
#' @param annotation An optional character string specifying the value of the
#' \code{RequesterAnnotation} field for a batch of HITs. This can be used to
#' disable all HITs from a \dQuote{batch} created in the online Requester User
#' Interface (RUI). To use a batch ID, the batch must be written in a character
#' string of the form \dQuote{BatchId:78382;}, where \dQuote{73832} is the
#' batch ID shown in the RUI. Must specify \code{hit} xor \code{hit.type} xor
#' \code{annotation}.
#' @param approve.pending.assignments A logical indicating whether the pending
#' assignments should be approved when the HIT is disabled.
#' @param skip.delete.prompt A logical indicating whether to skip the prompt that
#' asks you to confirm the delete operation. If TRUE, you will not be asked to
#' confirm that you wish to Delete the HITs. This is a safeguard flag to protect
#' the user from mistakenly deleting HITs.
#' @param verbose Optionally print the results of the API request to the
#' standard output. Default is taken from \code{getOption('pyMTurkR.verbose',
#' TRUE)}.
#' @return A data frame containing a list of HITs and whether the request to
#' disable each of them was valid.
#' @author Tyler Burleigh, Thomas J. Leeper
#' @references
#' \href{https://docs.aws.amazon.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_UpdateExpirationForHITOperation.html}{API Reference: Update Expiration for HIT}
#' \href{https://docs.aws.amazon.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_DeleteHITOperation.html}{API Reference: Delete HIT}
#' @keywords HITs
#' @examples
#'
#' \dontrun{
#' # Disable a single HIT
#' hittype1 <- RegisterHITType(title = "10 Question Survey",
#'                 description = "Complete a 10-question survey about news coverage and your opinions",
#'                 reward = ".20",
#'                 duration = seconds(hours=1),
#'                 keywords = "survey, questionnaire, politics")
#' a <- GenerateExternalQuestion("https://www.example.com/", "400")
#' hit1 <- CreateHIT(hit.type = hittype1$HITTypeId,
#'                  assignments = 1,
#'                  expiration = seconds(days=1),
#'                  question = a$string)
#'
#' DisableHIT(hit = hit1$HITId)
#'
#' # Disable all HITs of a given HITType
#' DisableHIT(hit.type = hit1$HITTypeId)
#'
#' # Disable all HITs of a given batch from the RUI
#' DisableHIT(annotation="BatchId:78382;")
#'
#' # Delete the HIT previously disabled
#' DeleteHIT(hit = hit1$HITId)
#' }
#'
#' @export DisableHIT
#' @export DisposeHIT
#' @export ExpireHIT
#' @export DeleteHIT
#' @export disablehit
#' @export disposehit
#' @export deletehit

DisableHIT <-
  DisposeHIT <-
  DeleteHIT <-
  ExpireHIT <-
  disablehit <-
  disposehit <-
  deletehit <-
  expirehit <-
  function(hit = NULL,
           hit.type = NULL,
           annotation = NULL,
           approve.pending.assignments = FALSE,
           skip.delete.prompt = FALSE,
           verbose = getOption('pyMTurkR.verbose', TRUE)) {

    client <- GetClient() # Boto3 client

    # Check if user is calling with delete aliases
    if((match.call()[[1]] == "DeleteHIT" | match.call()[[1]] == "deletehit" |
        match.call()[[1]] == "DisposeHIT" | match.call()[[1]] == "disposehit")){

      delete.hit = TRUE

      if(!skip.delete.prompt){
        utils::menu(c("Yes", "No"), title="Are you sure you want to Delete the HITs?") -> ans
        if(ans == 2){
          stop("User aborted operation.")
        }
      }

    } else {
      delete.hit = FALSE
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
      hitsearch <- SearchHITs(verbose = FALSE)
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

    HITs <- emptydf(length(hitlist), 3, c("HITId", "Operation", "Valid"))

    for (i in 1:length(hitlist)) {

      hit <- hitlist[i]

      if(!delete.hit){

        # Disable HIT
        # It might seem strange what we're doing here:
        #   in order to disable the HIT, we have to set its
        #   expiration to a time in the past. The expiration
        #   is in "epoch" time and it doesn't accept a 0 value
        #   or really any value less than 10000 it seems
        #   but 10000 is still "in the past" so it works
        response <- try(client$update_expiration_for_hit(
          HITId = hit,
          ExpireAt = "10000"
        ))
        operation <- "Disable/Expire"

        if(class(response) == "try-error") {
          warning(i, ": Invalid Request for HIT ", hit)
          valid <- FALSE
        } else {
          if(verbose){
            message(i, ": HIT ", hitlist[i], " Disabled")
          }
          valid <- TRUE
        }
        if(approve.pending.assignments){
          # Approve pending assignments
          ApproveAllAssignments(hit = hit, verbose = FALSE)
          operation <- paste0(operation, "; Approve Pending")
        }

      } else {
        operation <- "Delete"
        # Check HIT status
        hitdetail <- GetHIT(hit = hit, verbose = FALSE)
        if(hitdetail$HITs$HITStatus %in% c("Reviewing", "Reviewable")){
          response <- try(client$delete_hit(HITId = hit))

          if(class(response) == "try-error") {
            warning(i, ": Unable to Delete HIT ", hit)
            valid <- FALSE
          } else {
            message(i, ": HIT ", hitlist[i], " Deleted")
            valid <- TRUE
          }
        } else {
          warning(i, ": Unable to Delete HIT ", hit, " with status ", hitdetail$HITs$HITStatus)
          valid <- FALSE
        }
      }
      HITs[i, ] <- c(hit, operation, valid)
    }
    return(HITs)
  }
