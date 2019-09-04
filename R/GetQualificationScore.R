#' Get a Worker's Qualification Score
#'
#' Get a Worker's score for a specific Qualification. You can only retrieve
#' scores for custom QualificationTypes.
#'
#' A function to retrieve one or more scores for a specified QualificationType.
#' To retrieve all Qualifications of a given QualificationType, use
#' \code{\link{GetQualifications}} instead. Both \code{qual} and \code{workers}
#' can be vectors. If \code{qual} is not length 1 or the same length as
#' \code{workers}, an error will occur.
#'
#' \code{qualscore()} is an alias.
#'
#' @aliases GetQualificationScore qualscore
#' @param qual A character string containing a QualificationTypeId for a custom
#' QualificationType.
#' @param workers A character string containing a WorkerId, or a vector of
#' character strings containing multiple WorkerIds, whose Qualification Scores
#' you want to retrieve.
#' @param verbose Optionally print the results of the API request to the
#' standard output. Default is taken from \code{getOption('pyMTurkR.verbose',
#' TRUE)}.
#' @return A data frame containing the QualificationTypeId, WorkerId, time the
#' qualification was granted, the Qualification score, a column indicating the
#' status of the qualification, and a column indicating whether the API request
#' was valid.
#' @author Tyler Burleigh, Thomas J. Leeper
#' @seealso \code{\link{UpdateQualificationScore}}
#'
#' \code{\link{GetQualifications}}
#' @references
#' \href{https://docs.aws.amazon.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_ListWorkersWithQualificationTypeOperation.html}{API Reference}
#' @keywords Qualifications
#' @examples
#'
#' \dontrun{
#' qual1 <-
#' AssignQualification(workers = "A1RO9UJNWXMU65",
#'                     name = "Worked for me before",
#'                     description = "This qualification is for people who have worked for me before",
#'                     status = "Active",
#'                     keywords = "Worked for me before")
#'
#' GetQualificationScore(qual1$QualificationTypeId, qual1$WorkerId)
#'
#' # cleanup
#' DisposeQualificationType(qual1$QualificationTypeId)
#' }
#'
#' @export GetQualificationScore
#' @export qualscore

GetQualificationScore <-
  qualscore <-
  function (qual,
            workers,
            verbose = getOption('pyMTurkR.verbose', TRUE)) {

    GetClient() # Boto3 client

    if (is.factor(qual)) {
      qual <- as.character(qual)
    }
    if (length(qual) == 1) {
      qual <- rep(qual, length(workers))
    } else if(length(qual) != length(workers)) {
      stop("length(qual) != length(workers)")
    }
    if (is.factor(workers)) {
      workers <- as.character(workers)
    }

    Qualifications <- emptydf(length(workers), 6, c("QualificationTypeId",
                                                    "WorkerId", "GrantTime",
                                                    "Value", "Status", "Valid"))


    for (i in 1:length(workers)) {

      response <- try(pyMTurkR$Client$get_qualification_score(QualificationTypeId = qual[i],
                                                     WorkerId = workers[i]), silent = !verbose)

      # Validity check response
      if(class(response) != "try-error") {
        Qualifications[i,] <- ToDataFrameQualifications(response$Qualification)
        Qualifications[i,]$Valid <- TRUE
        if (verbose) {
          message("Qualification (", qual[i], ") Score for ", workers[i], ": ", Qualifications$Value[i])
        }
      } else {
        Qualifications[i,] <-
          c(QualificationTypeId = qual[i],
            WorkerId = workers[i],
            GrantTime = NA,
            Value = NA,
            Status = NA,
            Valid = FALSE)
        if (verbose) {
          warning("Invalid Request for worker ", workers[i])
        }
      }
    }

    return(Qualifications)

  }
