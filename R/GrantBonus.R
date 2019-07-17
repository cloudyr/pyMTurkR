#' Contact Worker(s)
#'
#' Contact one or more workers. This sends an email with specified subject line
#' and body text to one or more workers. This can be used to recontact workers
#' in panel/longitudinal research or to send follow-up work.
#'
#' Send an email to one or more workers, either with a common subject and body
#' text or subject and body customized for each worker.
#'
#' In batch mode (when \code{batch=TRUE}), workers are contacted in batches of
#' 100 with a single identical email. If one email fails (e.g., for one worker)
#' the other emails should be sent successfully. That is to say, the request as
#' a whole will be valid but will return additional information about which
#' workers were not contacted. This information can be found in the MTurkR log
#' file and viewing the XML responses directly.
#'
#' Note: It is only possible to contact workers who have performed work for you
#' previously. When attempting to contact a worker who has not worked for you
#' before, this function will indicate that the request was successful even
#' though the email is not sent. The function will return a value of
#' \dQuote{HardFailure} for \code{Valid} when this occurs. The printed results
#' may therefore appear contradictory because MTurk reports that requests to
#' contact these workers are \code{Valid}, but they are not actually contacted.
#' In batch, this means that a batch will be valid but individual ineligible
#' workers will be reported as not contacted.
#'
#' \code{ContactWorkers()}, \code{contact()}, \code{NotifyWorkers},
#' \code{NotifyWorker()}, and \code{notify()} are aliases.
#'
#' @aliases ContactWorker ContactWorkers contact NotifyWorkers notify
#' @param subjects A character string containing subject line of an email, or a
#' vector of character strings of of length equal to the number of workers to
#' be contacted containing the subject line of the email for each worker.
#' Maximum of 200 characters.
#' @param msgs A character string containing body text of an email, or a vector
#' of character strings of of length equal to the number of workers to be
#' contacted containing the body text of the email for each worker. Maximum of
#' 4096 characters.
#' @param workers A character string containing a WorkerId, or a vector of
#' character strings containing multiple WorkerIds.
#' @param batch A logical (default is \code{FALSE}), indicating whether workers
#' should be contacted in batches of 100 (the maximum allowed by the API). This
#' significantly reduces the time required to contact workers, but eliminates
#' the ability to send customized messages to each worker.
#' @return A data frame containing the list of workers, subjects, and messages,
#' and whether the request to contact each of them was valid.
#' @author Tyler Burleigh, Thomas J. Leeper
#' @references
#' \href{https://docs.aws.amazon.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_NotifyWorkersOperation.html}{API
#' Reference}
#' @keywords Workers
#' @examples
#'
#' \dontrun{
#' a <- "Complete a follow-up survey for $.50"
#' b <- "Thanks for completing my HIT!
#' I will pay a $.50 bonus if you complete a follow-up survey by Friday at 5:00pm.
#' The survey can be completed at
#' http://www.surveymonkey.com/s/pssurvey?c=A1RO9UEXAMPLE."
#'
#' # contact one worker
#' c1 <- "A1RO9UEXAMPLE"
#' d <- ContactWorker(subjects = a,
#'                    msgs = b,
#'                    workers = c1)
#'
#' # contact multiple workers in batch
#' c2 <- c("A1RO9EXAMPLE1","A1RO9EXAMPLE2","A1RO9EXAMPLE3")
#' e <- ContactWorker(subjects = a,
#'                    msgs = b,
#'                    workers = c2,
#'                    batch = TRUE)
#' }
#'

GrantBonus <-
  bonus <-
  paybonus <-
  function (workers, assignments, amounts, reasons, verbose = TRUE){

    client <- GetClient() # Boto3 client

    if (is.factor(reasons)) {
      reasons <- as.character(reasons)
    }
    if (is.factor(workers)) {
      workers <- as.character(workers)
      if (length(workers) > length(unique(workers))) {
        warning("Duplicated WorkerIds removed from 'workers'")
      }
      workers <- unique(workers)
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
        stop(paste("Message ", i, "Text Too Long (4096 char max)", sep = ""))
      }
    }
    if (length(reasons) == 1) {
      reasons <- rep(reasons[1], length(workers))
    } else if (!length(reasons) == length(workers)) {
      stop("Number of messages is not 1 nor length(workers)")
    }
    if (length(amounts) == 1) {
      amounts <- rep(amounts[1], length(workers))
    } else if (!length(amounts) == length(workers)) {
      stop("Number of amounts is not 1 nor length(workers)")
    }
    if (!length(assignments) == length(workers)) {
      stop("Number of assignments is not length(workers)")
    }

    Bonuses <- emptydf(length(workers), 5, c("WorkerId", "Assignment", "Amount", "Reason", "Valid"))

    for (i in 1:length(workers)) {

      response <- try(client$send_bonus(
        WorkerId = workers[i],
        BonusAmount = amounts[i],
        AssignmentId = assignments[i],
        Reason = reasons[i]
      ))

      # Check if failure
      if (response$ResponseMetadata$HTTPStatusCode == 200) {
        valid <- TRUE
      } else {
        valid <- FALSE
      }

      Bonuses[i, ] <- c(workers[i], amounts[i], assignments[i], reasons[i], valid)

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
