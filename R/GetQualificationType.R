#' Get QualificationType
#'
#' Get the details of a Qualification Type.
#'
#' Retrieve characteristics of a specified QualificationType (as originally
#' specified by \code{\link{CreateQualificationType}}).
#'
#' \code{qualtype()} is an alias.
#'
#' @aliases GetQualificationType qualtype
#' @param qual A character string containing a QualificationTypeId.
#' @param verbose Optionally print the results of the API request to the
#' standard output. Default is taken from \code{getOption('pyMTurkR.verbose',
#' TRUE)}.
#' @return A data frame containing the QualificationTypeId of the newly created
#' QualificationType and other details as specified in the request.
#' @author Tyler Burleigh, Thomas J. Leeper
#' @references
#' \href{https://docs.aws.amazon.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_GetQualificationTypeOperation.html}{API Reference}
#' @keywords Qualifications
#' @examples
#'
#' \dontrun{
#' qual1 <- CreateQualificationType(name="Worked for me before",
#'     description="This qualification is for people who have worked for me before",
#'     status = "Active",
#'     keywords="Worked for me before")
#' GetQualificationType(qual1$QualificationTypeId)
#' DisposeQualificationType(qual1$QualificationTypeId)
#' }
#'
#' @export GetQualificationType
#' @export qualtype

GetQualificationType <-
  qualtype <-
  function(qual, verbose = getOption('pyMTurkR.verbose', TRUE)) {

    GetClient() # Boto3 client

    if (is.null(qual)) {
      stop("Must specify QualificationTypeId")
    }
    if(is.factor(qual)){
      qual <- as.character(qual)
    }

    response <- try(pyMTurkRClient$get_qualification_type(QualificationTypeId = qual), silent = !verbose)

    # Validity check response
    if(class(response) == "try-error") {
      Qualifications <- emptydf(nrow=0, ncol=13, c("QualificationTypeId", "CreationTime", "Name", "Description",
                                   "Keywords", "QualificationTypeStatus", "AutoGranted", "AutoGrantedValue",
                                   "IsRequestable", "RetryDelayInSeconds", "TestDurationInSeconds",
                                   "Test","AnswerKey"))
      if (verbose) {
        warning("Invalid Request")
      }
    } else {
      Qualifications <- ToDataFrameQualificationTypes(list(response$QualificationType))
      if (verbose) {
        message("QualificationType Retrieved: ", qual)
      }
    }

    return(Qualifications)
  }
