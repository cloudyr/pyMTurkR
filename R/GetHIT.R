#' Get HIT
#'
#' Retrieve various details of a HIT as a data frame.
#'
#' \code{GetHIT} retrieves characteristics of a HIT. \code{HITStatus} is a
#' wrapper that retrieves the Number of Assignments Pending, Number of
#' Assignments Available, Number of Assignments Completed for the HIT(s), which
#' is helpful for checking on the progress of currently available HITs.
#'
#' \code{gethit()} and \code{hit()} are aliases for \code{GetHIT}.
#' @aliases GetHIT gethit hit
#' @param hit A character string specifying the HITId of the HIT to be retrieved.
#' @param return.hit.dataframe A logical indicating whether the data frame of
#' HITs should be returned. Default is \code{TRUE}.
#' @param return.qual.dataframe A logical indicating whether the list of each
#' HIT's QualificationRequirements (stored as data frames in that list) should
#' be returned. Default is \code{TRUE}.
#' @author Tyler Burleigh, Thomas J. Leeper
#' @references
#' \href{https://docs.aws.amazon.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_GetHITOperation.html}{API Reference}
#' @keywords HITs
#'

GetHIT <-
  gethit <-
  hit <-
  function(hit,
           return.hit.dataframe = TRUE,
           return.qual.dataframe = TRUE,
           verbose = TRUE){

    client <- GetClient() # Boto3 client
    response <- try(client$get_hit(HITId = hit))

    if (class(response) != "try-error") {
      hit <- list(response$HIT) # Hack for 1 result
      if (verbose) {
        message("HIT (", hit, ") Retrieved")
      }
      if (return.hit.dataframe == TRUE & return.qual.dataframe == TRUE) {
        return.list <- list(HITs = as.data.frame.HITs(hit),
                            QualificationRequirements = as.data.frame.QualificationRequirements(hit))
      } else if (return.hit.dataframe == TRUE & return.qual.dataframe == FALSE) {
        return.list <- list(HITs = as.data.frame.HITs(hit))
      } else if (return.hit.dataframe == FALSE & return.qual.dataframe == TRUE) {
        return.list <- list(QualificationRequirements = as.data.frame.QualificationRequirements(hit))
      } else {
        return.list <- list()
      }
    } else {
      if (verbose) {
        message("No HITs Retrieved")
      }
      return.list <- list()
    }
    return(return.list)
  }
