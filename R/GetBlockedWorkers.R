GetBlockedWorkers <-
  blockedworkers <-
  list_worker_blocks <-
  function(return.pages = NULL, results = as.integer(100),
           pagetoken = NULL, verbose = TRUE) {

    client <- GetClient() # Boto3 client

    batch <- function(pagetoken = NULL) {

      # Use page token if given
      if(!is.null(pagetoken)){
        response <- try(client$list_worker_blocks(NextToken = pagetoken,
                                                  MaxResults = as.integer(results)))
      } else {
        response <- try(client$list_worker_blocks(MaxResults = as.integer(results)))
      }

      # Validity check response
      if(class(response) == "try-error") {
        stop("Request failed")
      }

      if(response$NumResults > 0){
        response$WorkerBlocks <- as.data.frame.WorkerBlock(response$WorkerBlocks)
        return(response)
      } else {
        stop("No HITs found")
      }
    }

    # Fetch first page
    response <- batch()
    results.found <- response$NumResults
    to.return <- response

    # Keep a running total of all HITs returned
    runningtotal <- response$NumResults
    pages <- 1

    if (!is.null(response$NextToken)) { # continue to fetch pages

      # Starting with the next page, identified using NextToken
      pagetoken <- response$NextToken

      # Fetch while the number of results is equal to max results per page
      while (results.found == results &
             (is.null(return.pages) || pages < return.pages)) {

        # Fetch next batch
        response <- batch(pagetoken)

        # Add to HIT DF
        to.return$WorkerBlocks <- rbind(to.return$WorkerBlocks, response$WorkerBlocks)

        # Add to running total
        runningtotal <- runningtotal + response$NumResults
        results.found <- response$NumResults

        # Update page token
        if(!is.null(response$NextToken)){
          pagetoken <- response$NextToken
        }
        pages <- pages + 1
      }
    }

    if (verbose) {
      message(runningtotal, " Blocked Workers Found")
    }
    return(to.return$WorkerBlocks)
  }
