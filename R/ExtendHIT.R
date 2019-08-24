#' Extend HIT
#'
#' Extend the time remaining on a HIT or the number of assignments available
#' for the HIT.
#'
#' A useful function for adding time and/or additional assignments to a HIT. If
#' the HIT is already expired, this reactivates the HIT for the specified
#' amount of time. If all assignments have already been submitted, this
#' reactivates the HIT with the specified number of assignments and previously
#' specified expiration. Must specify a HITId xor a HITTypeId. If multiple HITs
#' or a HITTypeId are specified, each HIT is extended by the specified amount.
#'
#' \code{extend()} is an alias.
#'
#' @aliases ExtendHIT extend
#' @param hit An optional character string containing a HITId or a vector of
#' character strings containing multiple HITIds. Must specify \code{hit} xor
#' \code{hit.type} xor \code{annotation}.
#' @param hit.type An optional character string containing a HITTypeId (or a
#' vector of HITTypeIds). Must specify \code{hit} xor \code{hit.type} xor
#' \code{annotation}.
#' @param annotation An optional character string specifying the value of the
#' \code{RequesterAnnotation} field for a batch of HITs. This can be used to
#' extend all HITs from a \dQuote{batch} created in the online Requester User
#' Interface (RUI). To use a batch ID, the batch must be written in a character
#' string of the form \dQuote{BatchId:78382;}, where \dQuote{73832} is the
#' batch ID shown in the RUI. Must specify \code{hit} xor \code{hit.type} xor
#' \code{annotation}.
#' @param add.assignments An optional character string containing the number of
#' assignments to add to the HIT. Must be between 1 and 1000000000.
#' @param add.seconds An optional character string containing the amount of
#' time to extend the HIT, in seconds (for example, returned by
#' \code{\link{seconds}}). Must be between 1 hour (3600 seconds) and 365 days.
#' @param unique.request.token An optional character string, included only for
#' advanced users.
#' @param verbose Optionally print the results of the API request to the
#' standard output. Default is taken from \code{getOption('pyMTurkR.verbose',
#' TRUE)}.
#' @return A data frame containing the HITId, assignment increment, time
#' increment, and whether each extension request was valid.
#' @author Tyler Burleigh, Thomas J. Leeper
#' @references
#' \href{https://docs.aws.amazon.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_UpdateExpirationForHITOperation.html}{API Reference: Update Expiration}
#' \href{https://docs.aws.amazon.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_CreateAdditionalAssignmentsForHITOperation.html}{API Reference: Create Additional Assignments for HIT}
#' @keywords HITs
#' @examples
#'
#' \dontrun{
#' a <- GenerateExternalQuestion("https://www.example.com/","400")
#' hit1 <- CreateHIT(title = "Example",
#'                   description = "Simple Example HIT",
#'                   reward = ".01",
#'                   expiration = seconds(days = 4),
#'                   duration = seconds(hours = 1),
#'                   keywords = "example",
#'                   question = a$string)
#'
#' # add assignments
#' ExtendHIT(hit = hit1$HITId, add.assignments = "20")
#'
#' # add time
#' ExtendHIT(hit = hit1$HITId, add.seconds = seconds(days=1)))
#'
#' # add assignments and time
#' ExtendHIT(hit = hit1$HITId, add.assignments = "20", add.seconds = seconds(days=1)))
#'
#' # cleanup
#' DisableHIT(hit = hit1$HITId)
#'
#' }
#' \dontrun{
#' # Extend all HITs of a given batch from the RUI
#' ExtendHIT(annotation="BatchId:78382;", add.assignments = "20")
#' }
#'
#' @export

ExtendHIT <-
  extend <-
  function(hit = NULL,
           hit.type = NULL,
           annotation = NULL,
           add.assignments = NULL,
           add.seconds = NULL,
           unique.request.token = NULL,
           verbose = getOption('pyMTurkR.verbose', TRUE)) {

    client <- GetClient() # Boto3 client

    if (is.null(add.assignments) & is.null(add.seconds)) {
      stop("Must specify more assignments or time (in seconds)")
    }
    if (!is.null(add.assignments)) {
      if (!is.numeric(add.assignments) & !is.numeric(as.numeric(add.assignments))) {
        stop("Assignment increment is non-numeric")
      } else if (as.numeric(add.assignments) < 1 | as.numeric(add.assignments) > 1e+09) {
        stop("Assignment increment must be between 1 and 1000000000")
      }
    }
    if (!is.null(add.seconds)) {
      if (!is.numeric(add.seconds) & !is.numeric(as.numeric(add.seconds))) {
        stop("Expiration increment is non-numeric")
      } else if (as.numeric(add.seconds) < 3600 | as.numeric(add.seconds) > 31536000) {
        stop("Expiration increment must be between 3600 and 31536000")
      }
    }

    # Validate hit, hit.type. annotation parameters -- must have one
    if (all(is.null(hit), is.null(hit.type), is.null(annotation))) {
      stop("Must provide 'hit' xor 'hit.type' xor 'annotation'")
    } else if (!is.null(hit)) {
      hitlist <- as.character(hit)
      hitdetails <- GetHIT(hit)
      expirations <- as.integer(hitdetails$HITs$Expiration)

    } else if (!is.null(hit.type)) {
      if (is.factor(hit.type)) {
        hit.type <- as.character(hit.type)
      }
      hitsearch <- SearchHITs(verbose = FALSE)
      hitlist <- hitsearch$HITs$HITId[hitsearch$HITs$HITTypeId %in% hit.type]
      expirations <- as.integer(hitsearch$HITs$Expiration[hitsearch$HITs$HITTypeId %in% hit.type])

    } else if (!is.null(annotation)) {
      if (is.factor(annotation)) {
        annotation <- as.character(annotation)
      }
      hitsearch <- SearchHITs(verbose = FALSE)
      hitlist <- hitsearch$HITs$HITId[grepl(annotation, hitsearch$HITs$RequesterAnnotation)]
      expirations <- as.integer(hitsearch$HITs$Expiration[grepl(annotation, hitsearch$HITs$RequesterAnnotation)])
    }
    if (length(hitlist) == 0 || is.null(hitlist)) {
      stop("No HITs found for HITType")
    }

    HITs <- emptydf(length(hitlist), 4, c("HITId", "ExtendOperation", "ExtendValue", "Valid"))

    for (i in 1:length(hitlist)) {
      hit <- hitlist[i]
      if(!is.null(add.assignments)){

        # List to store arguments
        args <- list()

        # Set the function to use later
        fun <- client$create_additional_assignments_for_hit

        # Add required arguments
        args <- c(args, list(HITId = hit,
                             NumberOfAdditionalAssignments = as.integer(add.assignments)))

        # Add request token if applicable
        if(!is.null(unique.request.token)){
          args <- c(args, list(UniqueRequestToken = unique.request.token))
        }

        # Execute the API call
        response <- try(
          do.call('fun', args)
        )

        if(class(response) == "try-error") {
          valid <- FALSE
          warning("Invalid Request")
        } else {
          valid <- TRUE
          message(i, ": HIT (", hit, ") Extended by ", add.assignments, " Assignments")
        }
        HITs[i, ] <- c(hit, "AddAssignments", add.assignments, valid)
      }

      if(!is.null(add.seconds)){

        response <- try(client$update_expiration_for_hit(
          HITId = hit,
          ExpireAt = as.character(as.integer(expirations[i]) + as.integer(add.seconds))
        ))
        if(class(response) == "try-error") {
          warning("Invalid Request")
          valid <- FALSE
        } else {
          valid <- TRUE
          message(i, ": HIT (", hit, ") Extended by ", add.seconds, " Seconds")
        }
        HITs[i, ] <- c(hit, "AddSeconds", add.seconds, valid)
      }
    }
    return(HITs)
  }
