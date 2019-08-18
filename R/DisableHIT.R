#' Disable HIT
#'
#' This function will allow you to expire a HIT early, which means it will no
#' longer be available for new workers to accept. Optionally, when disabling the
#' HIT you can approve all pending assignments and you can also try to delete
#' the HIT. Be careful when deleting a HIT: this will also delete the assignment
#' data!
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
#' @param delete.hit A logical indicating whether to try deleting the HIT
#' when the HIT is disabled. This will also delete the assignment data. Note
#' that the HIT can only be deleted if it has a "Reviewing" or "Reviewable"
#' status. In other words, you can't delete a HIT if someone is currently working
#' on an assignment for it.
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
#' b <- GenerateExternalQuestion("http://www.example.com/","400")
#' hit1 <- CreateHIT(hit.type="2FFNCWYB49F9BBJWA4SJUNST5OFSOW",
#'                   expiration = seconds(days = 1),
#'                   question=b$string)
#' DisableHIT(hit = hit1$HITId)
#'
#' # Disable all HITs of a given HITType
#' DisableHIT(hit.type = hit1$HITTypeId)
#'
#' # Disable all HITs of a given batch from the RUI
#' DisableHIT(annotation="BatchId:78382;")
#' }
#'
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
           delete.hit = FALSE,
           verbose = TRUE) {

    client <- GetClient() # Boto3 client

    # Cannot delete HIT unless also approving pending assignments
    if (delete.hit & !approve.pending.assignments) {
      stop("Cannot 'delete.hit' unless 'approve.pending.assignments' is also TRUE")
    }

    # Check if user is calling with alias DeleteHIT or deletehit and delete.hit parameter is FALSE
    if((match.call()[[1]] == "DeleteHIT" | match.call()[[1]] == "deletehit") & delete.hit == FALSE){
      warning("Called with DeleteHIT alias but 'delete.hit' parameter was FALSE.\n  HIT will not be deleted!")
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

    HITs <- emptydf(length(hitlist), 2, c("HITId", "Valid"))

    for (i in 1:length(hitlist)) {

      hit <- hitlist[i]
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
      if(class(response) == "try-error") {
        warning(i, ": Invalid Request for HIT ", hit)
        valid = FALSE
      } else {
        if(verbose){
          message(i, ": HIT ", hitlist[i], " Disabled")
        }
        if(approve.pending.assignments){
          # Approve pending assignments
          ApproveAllAssignments(hit = hit, verbose = FALSE)

          # If delete.hit.after
          if(delete.hit){

            # Check HIT status
            hitdetail <- GetHIT(hit = hit)
            if(hitdetail$HITs$HITStatus == "Reviewing" |
               hitdetail$HITs$HITStatus == "Reviewable"){
              response <- try(client$delete_hit(
                HITId = hit
              ))
              if(class(response) == "try-error") {
                warning(i, ": Unable to Delete HIT ", hit)
              } else {
                message(i, ": HIT ", hitlist[i], " Deleted")
              }
            } else {
              warning(i, ": Unable to Delete HIT ", hit, " with status ", hitdetail$HITs$HITStatus)
            }


          }
        }
        valid = TRUE
      }
      HITs[i, ] <- c(hit, valid)
    }
    return(HITs)
  }
