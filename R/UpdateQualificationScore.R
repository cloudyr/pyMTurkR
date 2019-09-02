#' Update a worker's score for a QualificationType
#'
#' Update a worker's score for a QualificationType that you created. Scores for
#' built-in QualificationTypes (e.g., location, worker statistics) cannot be
#' updated.
#'
#' A function to update the Qualification score assigned to one or more workers
#' for the specified custom QualificationType. The simplest use is to specify a
#' QualificationTypeId, a WorkerId, and a value to be assigned to the worker.
#' Scores for multiple workers can be updated in one request.
#'
#' Additionally, the \code{increment} parameter allows you to increase (or
#' decrease) each of the specified workers scores by the specified amount. This
#' might be useful, for example, to keep a QualificationType that records how
#' many of a specific style of HIT a worker has completed and increase the
#' value of each worker's score by 1 after they complete a HIT.
#'
#' This function will only affect workers who already have a score for the QualificationType.
#' If a worker is given who does not already have a score, they will not be modified.
#'
#' \code{updatequalscore()} is an alias.
#'
#' @aliases UpdateQualificationScore updatequalscore
#' @param qual A character string containing a QualificationTypeId.
#' @param workers A character string containing a WorkerId, or a vector of
#' character strings containing multiple WorkerIds.
#' @param values A character string containing an integer value to be assigned
#' to the worker, or a vector of character strings containing integer values to
#' be assigned to each worker (and thus must have length equal to the number of
#' workers).
#' @param increment An optional character string specifying, in lieu of
#' \dQuote{values}, the amount that each worker's current QualfiicationScore
#' should be increased (or decreased).
#' @param verbose Optionally print the results of the API request to the
#' standard output. Default is taken from \code{getOption('pyMTurkR.verbose',
#' TRUE)}.
#' @return A data frame containing the QualificationTypeId, WorkerId,
#' Qualification score, and whether the request to update each was valid.
#' @author Tyler Burleigh, Thomas J. Leeper
#' @seealso \code{\link{GetQualificationScore}}
#'
#' \code{\link{GetQualifications}}
#' @references
#' \href{http://docs.amazonwebservices.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_UpdateQualificationScoreOperation.html}{API Reference}
#' @keywords Qualifications
#' @examples
#'
#' \dontrun{
#' qual1 <- CreateQualificationType(name="Worked for me before",
#'     description="This qualification is for people who have worked for me before",
#'     status = "Active",
#'     keywords="Worked for me before")
#' AssignQualification(qual1$QualificationTypeId, "A1RO9UJNWXMU65", value="50")
#' UpdateQualificationScore(qual1$QualificationTypeId, "A1RO9UJNWXMU65", value="95")
#' UpdateQualificationScore(qual1$QualificationTypeId, "A1RO9UJNWXMU65", increment="1")
#' DisposeQualificationType(qual1$QualificationTypeId)
#' }
#'
#' @export UpdateQualificationScore
#' @export updatequalscore

UpdateQualificationScore <-
  updatequalscore <-
  function (qual,
            workers,
            values = NULL,
            increment = NULL,
            verbose = getOption('pyMTurkR.verbose', TRUE)){

    if(!is.null(values) && !is.null(increment)){
      stop("Must provide 'values' or set 'increment' to TRUE, but not both")
    }
    if (is.factor(qual)) {
      qual <- as.character(qual)
    }
    if (is.factor(workers)) {
      workers <- as.character(workers)
    }

    # Fetch current scores
    scores <- c()
    for (i in 1:length(workers)) {
      scores[i] <- GetQualificationScore(qual, workers[i])$Value[1]
      if (is.null(scores[i])) {
        scores[i] <- NA
      }
    }

    # Increment scores
    if (!is.null(increment)) {
      values <- NA
      values <- as.numeric(scores) + as.numeric(increment)
    }
    if (!is.null(values)) {
      for (i in 1:length(values)) {
        if (!is.numeric(as.numeric(values[i]))) {
          stop("Value is non-numeric or not coercible to numeric")
        }
      }
      if (length(values) == 1) {
        values <- rep(values[1], length(workers))
      }
      if (!length(workers) == length(values)) {
        stop("!length(workers)==length(values)")
      }
    } else {
      stop("Value(s) is/are missing")
    }

    Qualifications <- emptydf(length(workers), 4,
                              c("QualificationTypeId", "WorkerId", "Value", "Valid"))

    for (i in 1:length(workers)) {

      # Check if worker has existing score
      # and don't update if they didn't
      if(is.na(scores[i])){
        Qualifications[i, ] <- c(qual, workers[i], values[i], FALSE)
      } else {
        request <- AssignQualification(qual = qual,
                                       workers = workers[i],
                                       value = values[i],
                                       verbose = FALSE)

        valid <- as.logical(request$Valid)
        Qualifications[i, ] <- c(qual, workers[i], values[i], valid)

        if (valid & verbose) {
          message(i, ": Qualification Score for Worker ", workers[i], " updated to ", values[i])
        } else if (!valid & verbose) {
          warning(i, ": Invalid Request for worker ", workers[i])
        }
      }

    }
    if (verbose) {
      message(i, " Qualification Scores Updated")
    }
    Qualifications$Valid <- factor(Qualifications$Valid, levels=c('TRUE','FALSE'))
    return(Qualifications)
  }
