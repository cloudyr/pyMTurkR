#' Block/Unblock Worker(s)
#' 
#' Block or unblock a worker. This prevents a worker from completing any HITs
#' for you while they are blocked, but does not affect their ability to
#' complete work for other requesters or affect their worker statistics.
#' \code{GetBlockedWorkers} retrieves your list of currently blocked workers.
#' 
#' \code{BlockWorker} prevents the specified worker from completing any of your
#' HITs. \code{UnblockWorker} reverses this operation.
#' 
#' \code{GetBlockedWorkers} retrieves currently blocked workers and the reason
#' recorded for their block. This operation returns the first 65,535 blocked
#' workers (the default for \code{pagesize}; access to additional blocked
#' workers is available by specifying a \code{pagenumber} greater than 1.
#' 
#' \code{BlockWorkers()} and \code{block()} are aliases for \code{BlockWorker}.
#' \code{UnblockWorkers()} and \code{unblock()} are aliases for
#' \code{UnblockWorker}. \code{blockedworkers()} is an alias for
#' \code{GetBlockedWorkers}.
#' 
#' @aliases BlockWorker BlockWorkers block UnblockWorker UnblockWorkers unblock
#' GetBlockedWorkers blockedworkers
#' @param workers A character string containing a WorkerId, or a vector of
#' character strings containing multiple WorkerIds.
#' @param reasons A character string containing a reason for blocking or
#' unblocking a worker. This must have length 1 or length equal to the number
#' of workers. It is required for \code{BlockWorker} and optional for
#' \code{UnblockWorker}.
#' @param pagenumber An optional integer (or character string) indicating which
#' page of Blocked Workers search results should be returned. Most users can
#' ignore this.
#' @param pagesize An optional integer (or character string) indicating how
#' many Blocked Workers should be returned per page of results. Most users can
#' ignore this and the function will return the first 65,535 blocks.
#' @param verbose Optionally print the results of the API request to the
#' standard output. Default is taken from \code{getOption('MTurkR.verbose',
#' TRUE)}.
#' @param ... Additional arguments passed to \code{\link{request}}.
#' @return \code{BlockWorker} and \code{UnblockWorker} return a data frame
#' containing the list of workers, reasons (for blocking/unblocking them), and
#' whether the request to block/unblock each of them was valid.
#' 
#' \code{GetBlockedWorkers} returns a data frame containing the list of blocked
#' workers and the recorded reason for the block.
#' @author Thomas J. Leeper
#' @references
#' \href{http://docs.amazonwebservices.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_BlockWorkerOperation.htmlAPI
#' Reference: Block}
#' 
#' \href{http://docs.amazonwebservices.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_UnblockWorkerOperation.htmlAPI
#' Reference: Unblock}
#' 
#' \href{http://docs.amazonwebservices.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_GetBlockedWorkersOperation.htmlAPI
#' Reference: GetBlockedWorkers}
#' @keywords Workers
#' @examples
#' 
#' \dontrun{
#' % worker <- "A1RO9UJNWXMU65"
#' BlockWorker(worker, reasons="Did not follow photo categorization HIT instructions.")
#' GetBlockedWorkers()
#' UnblockWorker(worker)
#' }
#' 