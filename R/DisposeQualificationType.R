#' Dispose QualificationType
#'
#' Dispose of a QualificationType. This deletes the QualificationType,
#' Qualification scores for all workers, and all records thereof.
#'
#' A function to dispose of a QualificationType that is no longer needed. It will
#' dispose of the Qualification type and any HIT types that are associated with it.
#' It does not not revoke Qualifications already assigned to Workers. Any pending
#' requests for this Qualification are automatically rejected.
#'
#' \code{DisposeQualificationType()}, \code{disposequal()}, and \code{deletequal()}
#' are aliases.
#'
#' @aliases DisposeQualificationType DeleteQualificationType disposequal deletequal
#' @param qual A character string containing a QualificationTypeId.
#' @param verbose Optionally print the results of the API request to the
#' standard output. Default is taken from \code{getOption('pyMTurkR.verbose',
#' TRUE)}.
#' @return A data frame containing the QualificationTypeId and whether the
#' request to dispose was valid.
#' @author Tyler Burleigh, Thomas J. Leeper
#' @references
#' \href{https://docs.aws.amazon.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_DeleteQualificationTypeOperation.html}{API Reference}
#' @examples
#'
#' \dontrun{
#' qual1 <-
#' CreateQualificationType(name = "Worked for me before",
#'     description = "This qualification is for people who have worked for me before",
#'     status = "Active",
#'     keywords = "Worked for me before")
#' DisposeQualificationType(qual1$QualificationTypeId)
#' }
#'
#' @export DisposeQualificationType
#' @export DeleteQualificationType
#' @export disposequal
#' @export deletequal

DisposeQualificationType <-
  DeleteQualificationType <-
  disposequal <-
  deletequal <-
  function (qual, verbose = getOption('pyMTurkR.verbose', TRUE)) {

    GetClient() # Boto3 client

    operation <- "DisposeQualificationType"
    if (is.null(qual)) {
      stop("Must specify QualificationTypeId")
    } else {
      if (is.factor(qual)) {
        qual <- as.character(qual)
      }
    }

    QualificationTypes <- emptydf(0, 2, c("QualificationTypeId", "Valid"))

    response <- try(pyMTurkR$Client$delete_qualification_type(
      QualificationTypeId = qual
    ), silent = !verbose)

    if(class(response) == "try-error") {
      warning("Invalid request\n  Does this qualification exist?")
      return(emptydf(0, 2, c("QualificationTypeId", "Valid")))
    } else {
      QualificationTypes[1, ] <- c(qual, TRUE)
      if (verbose) {
        message("QualificationType ", qual, " Disposed")
      }
      return(QualificationTypes)
    }
  }
