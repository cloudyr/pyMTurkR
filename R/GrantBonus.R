#' Pay Bonus to Worker
#'
#' Pay a bonus to one or more workers. This function spends money from your
#' MTurk account and will fail if insufficient funds are available.
#'
#' A simple function to grant a bonus to one or more workers. The function is
#' somewhat picky in that it requires a WorkerId, the AssignmentId for an
#' assignment that worker has completed, an amount, and a reason for the bonus,
#' for each bonus to be paid. Optionally, the amount and reason can be
#' specified as single (character string) values, which will be used for each
#' bonus.
#'
#' \code{bonus()}, \code{paybonus()}, and \code{sendbonus()} are aliases.
#'
#' @aliases GrantBonus bonus paybonus sendbonus
#' @param workers A character string containing a WorkerId, or a vector of
#' character strings containing multiple WorkerIds.
#' @param assignments A character string containing an AssignmentId for an
#' assignment performed by that worker, or a vector of character strings
#' containing the AssignmentId for an assignment performed by each of the
#' workers specified in \code{workers}.
#' @param amounts A character string containing an amount (in U.S. Dollars) to
#' bonus the worker(s), or a vector (of length equal to the number of workers)
#' of character strings containing the amount to be paid to each worker.
#' @param reasons A character string containing a reason for bonusing the
#' worker(s), or a vector (of length equal to the number of workers) of
#' character strings containing the reason to bonus each worker. The reason is
#' visible to each worker and is sent via email.
#' @param unique.request.token An optional character string, included only for
#' advanced users. It can be used to prevent resending a bonus. A bonus will
#' not be granted if a bonus was previously granted (within a short time
#' window) using the same \code{unique.request.token}.
#' @param skip.prompt A logical indicating whether to skip the prompt that
#' asks you to continue when duplicate AssignmentIds are found. If TRUE, you will
#' not be asked to confirm. The prompt is a safeguard flag to protect the user from
#' mistakenly paying a bonus twice.
#' @param verbose Optionally print the results of the API request to the
#' standard output. Default is taken from \code{getOption('pyMTurkR.verbose',
#' TRUE)}.
#' @return A data frame containing the WorkerId, AssignmentId, amount, reason,
#' and whether each request to bonus was valid.
#' @author Tyler Burleigh, Thomas J. Leeper
#' @seealso \code{\link{GetBonuses}}
#' @references
#' \href{https://docs.aws.amazon.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_SendBonusOperation.html}{API Reference}
#' @keywords Workers
#' @examples
#'
#' \dontrun{
#' # Grant a single bonus
#' a <- "A1RO9UEXAMPLE"
#' b <- "26XXH0JPPSI23H54YVG7BKLEXAMPLE"
#' c <- ".50"
#' d <- "Thanks for your great work on my HITs!\nHope to work with you, again!"
#' GrantBonus(workers=a, assignments=b, amounts=c, reasons=d)
#' }
#' \dontrun{
#' # Grant bonuses to multiple workers
#' a <- c("A1RO9EXAMPLE1","A1RO9EXAMPLE2","A1RO9EXAMPLE3")
#' b <-
#' c("26XXH0JPPSI23H54YVG7BKLEXAMPLE1",
#' "26XXH0JPPSI23H54YVG7BKLEXAMPLE2",
#' "26XXH0JPPSI23H54YVG7BKLEXAMPLE3")
#' c <- c(".50",".10",".25")
#' d <- "Thanks for your great work on my HITs!"
#' GrantBonus(workers=a, assignments=b, amounts=c, reasons=d)
#' }
#'
#' @export GrantBonus
#' @export bonus
#' @export paybonus
#' @export sendbonus

GrantBonus <-
  bonus <-
  paybonus <-
  sendbonus <-
  function (workers,
            assignments,
            amounts,
            reasons,
            skip.prompt = FALSE,
            unique.request.token = NULL,
            verbose = getOption('pyMTurkR.verbose', TRUE)){

    GetClient() # Boto3 client

    if (is.factor(reasons)) {
      reasons <- as.character(reasons)
    }
    if (is.factor(workers)) {
      workers <- as.character(workers)
    }
    if (!skip.prompt & length(assignments) > length(unique(assignments))) {
      utils::menu(c("Yes", "No"),
                  title="Duplicate AssignmentIds.\nAre you sure you want to continue?") -> ans
      if(ans == 2){
        stop("User aborted operation.")
      }
    }

    # Check validity of parameters
    for (i in 1:length(workers)) {
      if (nchar(workers[i]) > 64) {
        stop(paste("WorkerId ", workers[i], " Too Long (64 char max)", sep = ""))
      } else if (nchar(workers[i]) < 1) {
        stop(paste("WorkerId ", workers[i], " Too Short (1 char min)", sep = ""))
      } else if (regexpr("^A[A-Z0-9]+$", workers[i])[[1]] == -1) {
        stop(paste("WorkerId ", workers[i], " Invalid format", sep = ""))
      }
    }
    for (i in 1:length(reasons)) {
      if (nchar(reasons[i]) > 4096) {
        stop(paste("Message ", i, " Text Too Long (4096 char max)", sep = ""))
      }
    }
    if (length(reasons) == 1) {
      reasons <- rep(reasons[1], length(workers))
    } else if (!length(reasons) == length(workers)) {
      stop("Number of reasons is not 1 nor length(workers)")
    }
    if (length(amounts) == 1) {
      amounts <- rep(amounts[1], length(workers))
    } else if (!length(amounts) == length(workers)) {
      stop("Number of amounts is not 1 nor length(workers)")
    }
    if (!length(assignments) == length(workers)) {
      stop("Number of assignments is not length(workers)")
    }
    if(is.numeric(amounts)){
      amounts <- as.character(amounts)
    }

    Bonuses <- emptydf(length(workers), 5, c("WorkerId", "Assignment", "Amount", "Reason", "Valid"))

    for (i in 1:length(workers)) {

      args <- list(WorkerId = workers[i],
                   BonusAmount = amounts[i],
                   AssignmentId = assignments[i],
                   Reason = reasons[i])

      if(!is.null(unique.request.token)){
        args <- c(args, UniqueRequestToken = unique.request.token)
      }

      fun <- pyMTurkR$Client$send_bonus

      # Execute the API call
      response <- try(
        do.call('fun', args), silent = !verbose
      )

      # Check if failure
      if (class(response) != "try-error") {
        valid <- TRUE
      } else {
        valid <- FALSE
      }

      Bonuses[i, ] <- c(workers[i], assignments[i], amounts[i], reasons[i], valid)

      # Message with results
      if (valid != TRUE) {
        if(verbose) {
          message(i, ": Worker (", workers[i], ") not granted bonus: ",
                  response[1])
        }
      }
      if (class(response) != "try-error" & valid == TRUE) {
        if (verbose) {
          message(i, ": Worker (", workers[i], ") Granted Bonus of ", amounts[i], " for Assignment ", assignments[i])
        }
      } else {
        if (verbose) {
          warning(i,": Invalid Request for worker ", workers[i])
        }
      }

    }

    return(Bonuses)

  }
