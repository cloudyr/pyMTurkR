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
#' \code{status()} is an alias for \code{HITStatus}.
#'
#' @aliases GetHIT gethit hit HITStatus status
#' @param hit A character string specifying the HITId of the HIT to be retrieved.
#' @param verbose Optionally print the results of the API request to the
#' standard output. Default is taken from \code{getOption('pyMTurkR.verbose',
#' TRUE)}.
#' @author Tyler Burleigh, Thomas J. Leeper
#' @references
#' \href{https://docs.aws.amazon.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_GetHITOperation.html}{API Reference}
#' @keywords HITs
#'
#' @examples
#'
#' \dontrun{
#' # register HITType
#' hittype <-
#' RegisterHITType(title="10 Question Survey",
#'                 description=
#'                 "Complete a 10-question survey about news coverage and your opinions",
#'                 reward=".20",
#'                 duration=seconds(hours=1),
#'                 keywords="survey, questionnaire, politics")
#'
#' a <- GenerateExternalQuestion("http://www.example.com/","400")
#' hit1 <-
#' CreateHIT(hit.type = hittype$HITTypeId, question = a$string)
#'
#' GetHIT(hit1$HITId)
#' HITStatus(hit1$HITId)
#'
#' # cleanup
#' DisableHIT(hit1$HITId)
#' }
#' \dontrun{
#' # Get the status of all HITs from a given batch from the RUI
#' HITStatus(annotation="BatchId:78382;")
#' }
#'
#'
#' @export GetHIT
#' @export gethit
#' @export hit
#' @export HITStatus
#' @export status

GetHIT <-
  gethit <-
  hit <-
  function(hit, verbose = getOption('pyMTurkR.verbose', TRUE)){

    GetClient() # Boto3 client
    response <- try(.pyMTurkRClient$get_hit(HITId = hit), silent = !verbose)

    if (class(response) != "try-error") {
      hitdetails <- list(response$HIT) # Hack for 1 result
      return.list <- list(HITs = ToDataFrameHITs(hitdetails),
                            QualificationRequirements = ToDataFrameQualificationRequirements(hitdetails))
    } else {
      if (verbose) {
        message("Error: No HITs Retrieved")
      }
      return.list <- list()
    }
    return(return.list)
  }
