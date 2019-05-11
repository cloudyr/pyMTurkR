#' Set HIT as \dQuote{Reviewing}
#' 
#' Update the review status of a HIT, from \dQuote{Reviewable} to
#' \dQuote{Reviewing} or the reverse.
#' 
#' A function to change the status of one or more HITs (or all HITs of a given
#' HITType) to \dQuote{Reviewing} or the reverse. This affects what HITs are
#' returned by \code{\link{GetReviewableHITs}}. Must specify a HITId xor a
#' HITTypeId.
#' 
#' \code{reviewing()} is an alias.
#' 
#' @aliases SetHITAsReviewing reviewing
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
#' standard output. Default is taken from \code{getOption('MTurkR.verbose',
#' TRUE)}.
#' @param ... Additional arguments passed to \code{\link{request}}.
#' @return A data frame containing HITId, status, and whether the request to
#' change the status of each was valid.
#' @author Thomas J. Leeper
#' @seealso \code{\link{GetReviewableHITs}}
#' @references
#' \href{http://docs.amazonwebservices.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_SetHITAsReviewingOperation.htmlAPI
#' Reference}
#' @keywords HITs
#' @examples
#' 
#' \dontrun{
#' a <- GenerateExternalQuestion("http://www.example.com/","400")
#' hit1 <- 
#' CreateHIT(hit.type="2FFNCWYB49F9BBJWA4SJUNST5OFSOW", question=a$string)
#' SetHITAsReviewing(hit1$HITId)
#' 
#' # cleanup
#' DisableHIT(hit1$HITId)
#' }
#' 