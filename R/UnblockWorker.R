UnblockWorker <-
  UnblockWorkers <-
  unblock <-
  DeleteWorkerBlock <-
  function (workers,
            reasons = NULL,
            verbose = getOption('pyMTurkR.verbose', TRUE)){

    GetClient() # Boto3 client

    if (is.factor(workers)) {
      workers <- as.character(workers)
    }
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


    Workers <- emptydf(length(workers), 3, c("WorkerId", "Reason", "Valid"))

    for (i in 1:length(workers)) {

      fun <- .pyMTurkRClient$delete_worker_block

      args <- list(WorkerId = workers[i])

      if(!is.null(reasons[i])){
        args <- c(args, list(Reason = reasons[i]))
        this.reason <- reasons[i]
      } else {
        this.reason <- NA
      }

      # Execute the API call
      response <- try(
        do.call('fun', args), silent = !verbose
      )

      # Validity check
      if(class(response) == "try-error") {
        valid = FALSE
        if(verbose){
          message(i, ": Worker ", workers[i], " Unblocked")
        }
      }
      else {
        valid = TRUE
        if(verbose){
          warning(i,": Invalid Request for worker ", workers[i])
        }
      }

      Workers[i, ] <- c(workers[i], this.reason, valid)

    }

    Workers$Valid <- factor(Workers$Valid, levels=c('TRUE','FALSE'))
    return(Workers)

  }
