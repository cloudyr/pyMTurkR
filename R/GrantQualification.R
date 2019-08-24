#' Grant/Accept or Reject a Qualification Request
#'
#' Gran/accept or reject a worker's request for a Qualification.
#'
#' Qualifications are publicly visible to workers on the MTurk website and
#' workers can request Qualifications (e.g., when a HIT requires a
#' QualificationType that they have not been assigned). QualificationRequests
#' can be retrieved via \code{\link{GetQualificationRequests}}.
#' \code{GrantQualification} grants the specified qualification requests.
#' Requests can be rejected with \code{\link{RejectQualifications}}.
#'
#' Note that granting a qualification may have the consequence of modifying a
#' worker's existing qualification score. For example, if a worker already has
#' a score of 100 on a given QualificationType and then requests the same
#' QualificationType, a \code{GrantQualification} action might increase or
#' decrease that worker's qualification score.
#'
#' Similarly, rejecting a qualification is not the same as revoking a worker's
#' Qualification. For example, if a worker already has a score of 100 on a
#' given QualificationType and then requests the same QualificationType, a
#' \code{RejectQualification} leaves the worker's existing Qualification in
#' place. Use \code{\link{RevokeQualification}} to entirely remove a worker's
#' Qualification.
#'
#' \code{GrantQualifications()}, \code{grantqual()}, \code{AcceptQualificationRequest()}
#' and \code{acceptrequest()} are aliases; \code{RejectQualifications()} and
#' \code{rejectrequest()} are aliases.
#'
#' @aliases GrantQualification GrantQualifications grantqual
#' AcceptQualificationRequest acceptrequest
#' RejectQualification RejectQualifications rejectrequest
#' @param qual.requests A character string containing a QualificationRequestId (for example, returned by \code{\link{GetQualificationRequests}}), or a vector of QualificationRequestIds.
#' @param values A character string containing the value of the Qualification
#' to be assigned to the worker, or a vector of values of length equal to the
#' number of QualificationRequests.
#' @param reason An optional character string, or vector of character strings
#' of length equal to length of the \code{qual.requests} parameter, supplying
#' each worker with a reason for rejecting their request for the Qualification.
#' Workers will see this message. Maximum of 1024 characters.
#' @param verbose Optionally print the results of the API request to the
#' standard output. Default is taken from \code{getOption('pyMTurkR.verbose',
#' TRUE)}.
#' @return A data frame containing the QualificationRequestId, reason for
#' rejection (if applicable; only for \code{RejectQualification}), and whether
#' each request was valid.
#' @author Tyler Burleigh, Thomas J. Leeper
#' @seealso \code{\link{GetQualificationRequests}}
#' @references
#' \href{https://docs.aws.amazon.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_AcceptQualificationRequestOperation.html}{API Reference: AcceptQualificationRequest}
#'
#' @keywords Qualifications
#'
#' @export GrantQualification
#' @export GrantQualifications
#' @export grantqual
#' @export AcceptQualificationRequest
#' @export acceptrequest
#' @export RejectQualification
#' @export RejectQualifications
#' @export rejectrequest

GrantQualification <-
  GrantQualifications <-
  grantqual <-
  AcceptQualificationRequest <-
  acceptrequest <-
  function(qual.requests,
           values,
           reason = NULL,
           verbose = getOption('pyMTurkR.verbose', TRUE)) {

    client <- GetClient() # Boto3 client

    if (is.factor(qual.requests)) {
      qual.requests <- as.character(qual.requests)
    }
    if (is.factor(values)) {
      values <- as.character(values)
    }
    if (!length(qual.requests) == length(values)) {
      if (length(values) == 1) {
        values <- rep(values[1], length(qual.requests))
      } else {
        stop("Number of QualificationRequests is not 1 or number of Values")
      }
    }
    for (i in 1:length(values)) {
      if (!is.numeric(as.numeric(values))) {
        warning("Non-numeric Qualification Value requested for request ",
                qual.requests[i], "\n", sep = "")
      }
    }

    # Empty df
    QualificationRequests <- emptydf(length(qual.requests), 3, c("QualificationRequestId", "Value", "Valid"))

    for (i in 1:length(qual.requests)) {

      response <- try(client$accept_qualification_request(QualificationRequestId = qual.requests[i],
                                                          IntegerValue = values[i]))


      # Check if failure
      if (response$ResponseMetadata$HTTPStatusCode == 200) {
        valid <- TRUE
      } else {
        valid <- FALSE
      }

      QualificationRequests[i, ] <- c(qual.requests[i], values[i], valid)

      # Message with results
      if (class(response) != "try-error" & valid == TRUE) {
        if (verbose) {
          message(i, ": Qualification (", qual.requests[i],") Granted")
        }
      } else {
        if (verbose) {
          warning(i, ": Invalid Request for QualificationRequest ", qual.requests[i])
        }
      }

    }
    QualificationRequests$Valid <- factor(QualificationRequests$Valid, levels=c('TRUE','FALSE'))
    return(QualificationRequests)
  }
