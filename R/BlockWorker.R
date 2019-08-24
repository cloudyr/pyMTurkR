#' Block Worker(s)
#'
#' Block a worker. This prevents a worker from completing any HITs
#' for you while they are blocked, but does not affect their ability to
#' complete work for other requesters or affect their worker statistics.
#'
#' \code{BlockWorker} prevents the specified worker from completing any of your
#' HITs.
#'
#' \code{BlockWorkers()}, \code{block()} and \code{CreateWorkerBlock()},
#' are aliases for \code{BlockWorker}. \code{UnblockWorkers()},
#' \code{unblock()}, and \code{DeleteWorkerBlock()} are aliases for
#' \code{UnblockWorker}. \code{blockedworkers()} is an alias for
#' \code{GetBlockedWorkers}.
#'
#' @aliases BlockWorker BlockWorkers block CreateWorkerBlock UnblockWorker
#' UnblockWorkers unblock DeleteWorkerBlock GetBlockedWorkers blockedworkers
#' ListWorkerBlocks listworkerblocks
#' @param workers A character string containing a WorkerId, or a vector of
#' character strings containing multiple WorkerIds.
#' @param reasons A character string containing a reason for blocking a worker.
#' This must have length 1 or length equal to the number of workers.
#' @param verbose Optionally print the results of the API request to the
#' standard output. Default is taken from \code{getOption('pyMTurkR.verbose',
#' TRUE)}.
#' @return \code{BlockWorker} returns a data frame containing the list of workers,
#' reasons (for blocking them), and whether the request to block was valid.
#'
#' @author Tyler Burleigh, Thomas J. Leeper
#' @references
#' \href{https://docs.aws.amazon.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_CreateWorkerBlockOperation.html}{API
#' Reference: Block}
#' @keywords Workers
#' @examples
#'
#' \dontrun{
#' BlockWorker("A1RO9UJNWXMU65", reasons="Did not follow HIT instructions.")
#' UnblockWorker("A1RO9UJNWXMU65")
#' }
#'
#' @export BlockWorker
#' @export BlockWorkers
#' @export block
#' @export CreateWorkerBlock
#' @export UnblockWorker
#' @export UnblockWorkers
#' @export unblock
#' @export DeleteWorkerBlock
#' @export GetBlockedWorkers
#' @export blockedworkers
#' @export ListWorkerBlocks
#' @export listworkerblocks

BlockWorker <-
  block <-
  BlockWorkers <-
  CreateWorkerBlock <-
  function (workers,
            reasons = NULL,
            verbose = getOption('pyMTurkR.verbose', TRUE)){

    client <- GetClient() # Boto3 client

    if (is.factor(workers)) {
      workers <- as.character(workers)
    }
    if (is.null(reasons)) {
      stop("Must specify one reason for block for all workers or one reason per worker")
    }
    if (is.factor(reasons)) {
      reasons <- as.character(reasons)
    }
    if (length(workers) > 1) {
      if (length(reasons) == 1) {
        reasons <- rep(reasons, length(workers))
      } else if (!length(workers) == length(reasons)) {
        stop("length(reasons) must equal length(workers) or 1")
      }
    }

    Workers <- emptydf(length(workers), 3, c("WorkerId", "Reason", "Valid"))

    for (i in 1:length(workers)) {

      response <- try(client$create_worker_block(
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
        message(i, ": Worker ", workers[i], " Blocked")
      } else if (valid == FALSE & verbose) {
        warning(i,": Invalid Request for worker ",workers[i])
      }

    }

    Workers$Valid <- factor(Workers$Valid, levels=c('TRUE','FALSE'))
    return(Workers)

  }
