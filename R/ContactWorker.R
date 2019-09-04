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
#' @aliases ContactWorker ContactWorkers contact NotifyWorkers notify NotifyWorker
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
#' @param verbose Optionally print the results of the API request to the
#' standard output. Default is taken from \code{getOption('pyMTurkR.verbose',
#' TRUE)}.
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
#' @export ContactWorker
#' @export contact
#' @export ContactWorkers
#' @export NotifyWorkers
#' @export NotifyWorker
#' @export notify

ContactWorker <-
  contact <-
  ContactWorkers <-
  NotifyWorkers <-
  NotifyWorker <-
  notify <-
  function (subjects,
            msgs,
            workers,
            batch = FALSE,
            verbose = getOption('pyMTurkR.verbose', TRUE)){

    GetClient() # Boto3 client

    if (is.factor(subjects)) {
      subjects <- as.character(subjects)
    }
    if (is.factor(msgs)) {
      msgs <- as.character(msgs)
    }
    if (is.factor(workers)) {
      workers <- as.character(workers)
    }
    if (length(workers) > length(unique(workers))) {
      warning("Duplicated WorkerIds removed from 'workers'")
      workers <- unique(workers)
    }

    # Batch run
    if (batch) {
      if (length(msgs) > 1) {
        stop("If 'batch'==TRUE, only one message can be used")
      } else if (nchar(subjects) > 200) {
        stop("Subject Too Long (200 char max)")
      }
      if (length(subjects) > 1) {
        stop("If 'batch'==TRUE, only one subject can be used")
      } else if (nchar(msgs) > 4096) {
        stop("Message Text Too Long (4096 char max)")
      }
      for (i in 1:length(workers)) {
        if (nchar(workers[i]) > 64) {
          stop(paste("WorkerId ", workers[i], " Too Long (64 char max)", sep = ""))
        } else if (nchar(workers[i]) < 1) {
          stop(paste("WorkerId ", workers[i], " Too Short (1 char min)", sep = ""))
        } else if (regexpr("^A[A-Z0-9]+$", workers[i])[[1]] == -1) {
          stop(paste("WorkerId ", workers[i], " Invalid format", sep = ""))
        }
      }

      # Prepare data frame for return
      Notifications <- emptydf(length(workers), 4, c("WorkerId", "Subject", "Message", "Valid"))
      Notifications$WorkerId <- workers
      Notifications$Subject <- subjects
      Notifications$Message <- msgs

      # Put into batches, then process
      workerbatch <- split(workers, rep(1:((length(workers) %/% 100) + 1), each = 100)[1:length(workers)])
      for (i in 1:length(workerbatch)) {
        response <- try(pyMTurkRClient$notify_workers(
          Subject = subjects,
          WorkerIds = as.list(workerbatch[[i]]),
          MessageText = msgs
        ), silent = !verbose)
        if (class(response) != "try-error") {
          Notifications$Valid[Notifications$WorkerId %in% workerbatch[[i]]] <- TRUE
          if (verbose) {
            message(i, ": Workers ", workerbatch[[i]][1], " to ", utils::tail(workerbatch[[i]],1), " Notified")
          }
          if (length(response$NotifyWorkersFailureStatuses) > 0) {
            for (k in 1:length(response$NotifyWorkersFailureStatuses)) {
              fail <- response$NotifyWorkersFailureStatuses[[k]]
              Notifications$Valid[Notifications$WorkerId == fail$WorkerId] <- 'HardFailure'
              if (verbose) {
                message(paste("Invalid Request for worker ", fail$WorkerId, ": ", fail$NotifyWorkersFailureMessage, sep=""))
              }
            }
          }
        } else {
          Notifications$Valid[Notifications$WorkerId %in% workerbatch[[i]]] <- FALSE
          if (verbose) {
            warning(i,": Invalid Request for workers ", workerbatch[[i]][1], " to ", utils::tail(workerbatch[[i]],1))
          }
        }
      }
    } else { # Not running as a batch

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
      for (i in 1:length(subjects)) {
        if (nchar(subjects[i]) > 200) {
          stop(paste("Subject ", i, " Too Long (200 char max)", sep = ""))
        }
      }
      for (i in 1:length(msgs)) {
        if (nchar(msgs[i]) > 4096) {
          stop(paste("Message ", i, "Text Too Long (4096 char max)", sep = ""))
        }
      }
      if (length(subjects) == 1) {
        subjects <- rep(subjects[1], length(workers))
      } else if (!length(subjects) == length(workers)) {
        stop("Number of subjects is not 1 nor length(workers)")
      }
      if (length(msgs) == 1) {
        msgs <- rep(msgs[1], length(workers))
      } else if (!length(msgs) == length(workers)) {
        stop("Number of messages is not 1 nor length(workers)")
      }

      Notifications <- emptydf(length(workers), 4, c("WorkerId", "Subject", "Message", "Valid"))

      for (i in 1:length(workers)) {

        response <- try(pyMTurkRClient$notify_workers(
          Subject = subjects[i],
          WorkerIds = as.list(workers[i]),
          MessageText = msgs[i]
        ), silent = !verbose)

        # Check if failure
        if (length(response$NotifyWorkersFailureStatuses) > 0) {
          valid <- response$NotifyWorkersFailureStatuses[[1]]$NotifyWorkersFailureCode
        } else {
          valid <- TRUE
        }

        Notifications[i, ] <- c(workers[i], subjects[i], msgs[i], valid)

        # Message with results
        if (valid != TRUE) {
          if(verbose) {
            message(i, ": Worker (", workers[i], ") not contacted: ",
                    response$NotifyWorkersFailureStatuses[[1]]$NotifyWorkersFailureMessage)
          }
        }
        if (class(response) != "try-error" & valid == TRUE) {
          if (verbose) {
            message(i, ": Worker (", workers[i], ") Notified")
          }
        } else {
          if (verbose) {
            warning(i,": Invalid Request for worker ", workers[i])
          }
        }

      }
    }

    Notifications$Valid <- factor(Notifications$Valid, levels=c('TRUE','FALSE','HardFailure'))
    return(Notifications)

  }
