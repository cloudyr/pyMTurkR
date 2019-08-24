#' Revoke a Qualification from a Worker
#'
#' Revoke a Qualification from a worker or multiple workers. This deletes their
#' qualification score and any record thereof.
#'
#' A simple function to revoke a Qualification assigned to one or more workers.
#'
#' \code{RevokeQualifications()}, \code{revokequal()} and
#' \code{DisassociateQualificationFromWorker()} are aliases.
#'
#' @aliases RevokeQualification RevokeQualifications revokequal
#' DisassociateQualificationFromWorker
#' @param qual A character string containing a QualificationTypeId.
#' @param workers A character string containing a WorkerId, or a vector of
#' character strings containing multiple WorkerIds.
#' @param reasons An optional character string, or vector of character strings
#' of length equal to length of the \code{workers} parameter, supplying each
#' worker with a reason for revoking their Qualification. Workers will see this
#' message.
#' @param verbose Optionally print the results of the API request to the
#' standard output. Default is taken from \code{getOption('pyMTurkR.verbose',
#' TRUE)}.
#' @return A data frame containing the QualificationTypeId, WorkerId, reason
#' (if applicable), and whether each request was valid.
#' @author Tyler Burleigh, Thomas J. Leeper
#' @seealso \code{\link{GrantQualification}}
#'
#' \code{\link{RejectQualification}}
#' @references
#' \href{https://docs.aws.amazon.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_DisassociateQualificationFromWorkerOperation.html}{API Reference}
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
#' RevokeQualification(qual = qual1$QualificationTypeId,
#'                     worker = qual1$WorkerId,
#'                     reason = "No longer needed")
#'
#' DisposeQualificationType(qual1$QualificationTypeId)
#'
#' }
#'
#' @export


RevokeQualification <-
  RevokeQualifications <-
  revokequal <-
  DisassociateQualificationFromWorker <-
  function (qual,
            workers,
            reasons = NULL,
            verbose = getOption('pyMTurkR.verbose', TRUE)){


    client <- GetClient() # Boto3 client

    if (!is.null(qual) & is.factor(qual)) {
      qual <- as.character(qual)
    }
    if (is.factor(workers)) {
      workers <- as.character(workers)
    }
    if (!is.null(reasons) && !length(reasons) == length(workers)) {
      if (length(reasons) == 1) {
        reasons <- rep(reasons[1], length(workers))
      } else {
        stop("Number of Reasons is not 1 or number of Workers")
      }
    }

    # Function for API call
    fun <- client$disassociate_qualification_from_worker

    Qualifications <- emptydf(0, 4, c("WorkerId", "QualificationTypeId", "Reason", "Valid"))

    for (i in 1:length(workers)) {

      args <- list(QualificationTypeId = qual,
                    WorkerId = workers[i])
      if(!is.null(reasons)){
        reason = reasons[i]
        args <- c(args, reasons =reason)
      } else {
        reason = ""
      }

      # Execute the API call
      response <- try(
        do.call('fun', args)
      )

      # Check if failure
      if (response$ResponseMetadata$HTTPStatusCode == 200) {
        message(i, ": Qualification (", qual, ") for worker ", workers[i], " Revoked")
        valid <- TRUE
      } else {
        warning(i, ": Invalid Request for worker ", workers[i])
        valid <- FALSE
      }
      Qualifications[i, ] = c(workers[i], qual, reason, valid)
    }

    Qualifications$Valid <- factor(Qualifications$Valid, levels=c('TRUE','FALSE'))
    return(Qualifications)

  }
