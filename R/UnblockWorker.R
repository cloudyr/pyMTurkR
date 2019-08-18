UnblockWorker <-
  UnblockWorkers <-
  unblock <-
  DeleteWorkerBlock <-
  function (workers,
            reasons = NULL,
            verbose = getOption('pyMTurkR.verbose', TRUE)){

    client <- GetClient() # Boto3 client

    if (is.factor(workers)) {
      workers <- as.character(workers)
    }
    if (length(workers) > 1) {
      if (!is.null(reasons)) {
        if (is.factor(reasons)) {
          reasons <- as.character(reasons)
        }
        if (length(reasons) == 1) {
          reasons <- rep(reasons, length(workers))
        } else if (!length(workers) == length(reasons)) {
          stop("length(reason) must equal length(workers) or 1")
        }
      }
    }


    Workers <- emptydf(length(workers), 3, c("WorkerId", "Reason", "Valid"))

    for (i in 1:length(workers)) {

      response <- try(client$delete_worker_block(
        WorkerId = workers[i],
        Reason = reasons[i]
      ))

      # Validity check
      if(class(response) == "try-error") {
        valid = FALSE
      }
      else {
        valid = TRUE
      }

      Workers[i, ] <- c(workers[i], reasons[i], valid)

      if (valid == TRUE & verbose) {
        message(i, ": Worker ", workers[i], " Unblocked")
      } else if (valid == FALSE & verbose) {
        warning(i,": Invalid Request for worker ",workers[i])
      }

    }

    Workers$Valid <- factor(Workers$Valid, levels=c('TRUE','FALSE'))
    return(Workers)

  }
