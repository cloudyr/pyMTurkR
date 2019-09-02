GetBlockedWorkers <-
  blockedworkers <-
  ListWorkerBlocks <-
  listworkerblocks <-
  function(results = as.integer(100),
           pagetoken = NULL,
           verbose = getOption('pyMTurkR.verbose', TRUE)) {

    client <- GetClient() # Boto3 client

    batch <- function(pagetoken = NULL) {

      # Use page token if given
      if(!is.null(pagetoken)){
        response <- try(client$list_worker_blocks(NextToken = pagetoken,
                                                  MaxResults = as.integer(results)), silent = !verbose)
      } else {
        response <- try(client$list_worker_blocks(MaxResults = as.integer(results)), silent = !verbose)
      }

      # Validity check response
      if(class(response) == "try-error") {
        stop("Request failed")
      }

      if(response$NumResults > 0){
        response$WorkerBlocks <- ToDataFrameWorkerBlock(response$WorkerBlocks)
        return(response)
      } else {
        return(emptydf(0, 2, c("WorkerId", "Reason")))
      }
    }

    # Fetch first page
    response <- batch(pagetoken)
    results.found <- response$NumResults
    to.return <- response

    if (!is.null(response$NextToken) & results > results.found) { # continue to fetch pages

      # Starting with the next page, identified using NextToken
      pagetoken <- response$NextToken

      # Fetch while the number of results is equal to max results per page
      while (results.found == results) {

        # Fetch next batch
        response <- batch(pagetoken)

        # Add to HIT DF
        to.return$WorkerBlocks <- rbind(to.return$WorkerBlocks, response$WorkerBlocks)

        # Update results found
        if(!is.null(response)){
          results.found <- response$NumResults
        } else {
          results.found <- 0
        }

        # Update page token
        if(!is.null(response$NextToken)){
          pagetoken <- response$NextToken
        }
      }
    }

    if (verbose) {
      message(nrow(to.return$WorkerBlocks), " Blocked Workers Found")
    }
    return(to.return$WorkerBlocks)
  }
