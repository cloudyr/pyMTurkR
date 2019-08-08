RejectQualification <-
  RejectQualifications <-
  rejectrequest <-
  function (qual.requests,
            reason = NULL,
            verbose = getOption('pyMTurkR.verbose', TRUE)) {

    client <- GetClient() # Boto3 client

    if (is.factor(qual.requests)) {
      qual.requests <- as.character(qual.requests)
    }
    if (!is.null(reason)) {
      if (is.factor(reason)) {
        reason <- as.character(reason)
      }
      if (!length(qual.requests) == length(reason)) {
        if (length(reason) == 1) {
          reason <- rep(reason[1], length(qual.requests))
        } else {
          stop("Number of QualificationRequests is not 1 or number of Reasons")
        }
      }
    }
    QualificationRequests <- emptydf(length(qual.requests), 3, c("QualificationRequestId", "Reason", "Valid"))

    for (i in 1:length(qual.requests)) {

      response <- try(client$reject_qualification_request(QualificationRequestId = qual.requests[i],
                                                          Reason = reason[i]))

      if (is.null(reason[i])) {
        reason[i] <- NA_character_
      }

      # Check if failure
      if (response$ResponseMetadata$HTTPStatusCode == 200) {
        valid <- TRUE
      } else {
        valid <- FALSE
      }

      QualificationRequests[i, ] <- c(qual.requests[i], reason[i], valid)

      # Message with results
      if (class(response) != "try-error" & valid == TRUE) {
        if (verbose) {
          message(i, ": Qualification (", qual.requests[i],") Rejected")
        }
      } else {
        if (verbose) {
          warning(i, ": Invalid Request for QualificationRequestId ", qual.requests[i])
        }
      }

    }
    QualificationRequests$Valid <- factor(QualificationRequests$Valid, levels=c('TRUE','FALSE'))
    return(QualificationRequests)

  }
