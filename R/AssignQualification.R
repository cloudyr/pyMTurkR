#' Assign Qualification
#'
#' Assign a Qualification to one or more workers. The QualificationType should
#' have already been created by \code{\link{CreateQualificationType}}, or the
#' details of a new QualificationType can be specified atomically. This
#' function also provides various options for automatically specifying the
#' value of a worker's QualificationScore based upon a worker's statistics.
#'
#' A very robust function to assign a Qualification to one or more workers. The
#' simplest use of the function is to assign a Qualification of the specified
#' value to one worker, but assignment to multiple workers is possible. Workers
#' can be assigned a Qualification previously created by
#' \code{\link{CreateQualificationType}}, with the characteristics of a new
#' QualificationType specified atomically, or a QualificationTypeID for a
#' qualification created in the MTurk RUI.
#'
#' \code{AssignQualifications()}, \code{assignqual()} and
#' \code{AssociateQualificationWithWorker()} are aliases.
#'
#' @aliases AssignQualification AssignQualifications assignqual
#' AssociateQualificationWithWorker
#' @param qual A character string containing a QualificationTypeId.
#' @param workers A character string containing a WorkerId, or a vector of
#' character strings containing multiple WorkerIds.
#' @param value A character string containing the value to be assigned to the
#' worker(s) for the QualificationType.
#' @param notify A logical indicating whether workers should be notified that
#' they have been assigned the qualification. Default is \code{FALSE}.
#' @param name An optional character string specifying a name for a new
#' QualificationType. This is visible to workers. Cannot be modified by
#' \code{UpdateQualificationType}.
#' @param description An optional character string specifying a longer
#' description of the QualificationType. This is visible to workers. Maximum of
#' 2000 characters.
#' @param keywords An optional character string containing a comma-separated
#' set of keywords by which workers can search for the QualificationType.
#' Cannot be modified by \code{UpdateQualificationType}. Maximum of 1000
#' characters.
#' @param status A character vector of \dQuote{Active} or \dQuote{Inactive},
#' indicating whether the QualificationType should be active and visible.
#' @param retry.delay An optional time (in seconds) indicating how long workers
#' have to wait before requesting the QualificationType after an initial
#' rejection.
#' @param test An optional character string consisting of a QuestionForm data
#' structure, used as a test a worker must complete before the
#' QualificationType is granted to them.
#' @param answerkey An optional character string consisting of an AnswerKey
#' data structure, used to automatically score the test.
#' @param test.duration An optional time (in seconds) indicating how long
#' workers have to complete the test.
#' @param auto A logical indicating whether the Qualification is automatically
#' granted to workers who request it. Default is \code{FALSE}.
#' @param auto.value An optional parameter specifying the value that is
#' automatically assigned to workers when they request it (if the Qualification
#' is automatically granted).
#' @param verbose Optionally print the results of the API request to the
#' standard output. Default is taken from \code{getOption('pyMTurkR.verbose',
#' TRUE)}.
#' @return A data frame containing the list of workers, the
#' QualificationTypeId, the value each worker was assigned, whether they were
#' notified of their QualificationType assignment, and whether the request was
#' valid.
#' @author Tyler Burleigh, Thomas J. Leeper
#' @references
#' \href{http://docs.amazonwebservices.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_AssignQualificationOperation.html}{API Reference}
#' @keywords Qualifications
#' @examples
#'
#' \dontrun{
#' qual1 <-
#' CreateQualificationType(name="Worked for me before",
#'     description="This qualification is for people who have worked for me before",
#'     status = "Active",
#'     keywords="Worked for me before")
#'
#' # assign qualification to single worker
#' AssignQualification(qual1$QualificationTypeId, "A1RO9UJNWXMU65", value = "50")
#'
#' # delete the qualification
#' DeleteQualificationType(qual1)
#'
#' # assign a new qualification (defined atomically)
#' AssignQualification(workers = "A1RO9UJNWXMU65",
#'                     name = "Worked for me before",
#'                     description = "This qualification is for people who have worked for me before",
#'                     status = "Active",
#'                     keywords = "Worked for me before")
#'}
#' @export AssignQualification
#' @export assignqual
#' @export AssignQualifications
#' @export AssociateQualificationWithWorker

AssignQualification <-
  assignqual <-
  AssignQualifications <-
  AssociateQualificationWithWorker <-
  function (qual = NULL, workers, value = 1,
            notify = FALSE, name = NULL, description = NULL,
            keywords = NULL, status = NULL, retry.delay = NULL,
            test = NULL, answerkey = NULL, test.duration = NULL,
            auto = NULL, auto.value = NULL,
            verbose = getOption('pyMTurkR.verbose', TRUE)) {

    GetClient() # Boto3 client

    if (!is.null(qual) & is.factor(qual)) {
      qual <- as.character(qual)
    }
    if (is.factor(workers)) {
      workers <- as.character(workers)
    }
    if (is.factor(value)) {
      value <- as.character(value)
    }
    if (!is.logical(notify) == TRUE) {
      stop("SendNotification must be TRUE or FALSE.")
    }
    for (i in 1:length(value)) {
      if (is.null(value[i]) || is.na(value[i]) || value[i]=='') {
        warning("Value ", i," not assigned; value assumed to be 1")
        value[i] <- as.integer(1)
      } else if(is.na(as.integer(value[i]))) {
        stop("value ", i," is not or cannot be coerced to integer")
      }
    }

    worker <- NULL

    # Function to batch process
    batch <- function(worker, value) {
      response <- try(.pyMTurkRClient$associate_qualification_with_worker(
        QualificationTypeId = qual,
        WorkerId = worker,
        IntegerValue = as.integer(value),
        SendNotification = as.logical(notify)
      ), silent = !verbose)

      # Validity check
      if(class(response) == "try-error") {
        return(data.frame(valid = FALSE))
      }
      else response$valid = TRUE

      if(verbose & response$valid)
        message("Qualification (", qual, ") Assigned to worker ", worker)
      return(invisible(response))
    }

    # Create a new Qualification Type, if defined atomically
    if (!is.null(name)) {
      if (!is.null(qual))
        stop("Cannot specify QualificationTypeId and properties of new QualificationType")
      if (is.null(description))
        stop("No Description provided for QualificationType")
      if (is.null(status) || !status == "Active") {
        warning("QualificationTypeStatus set to 'Active'")
        status <- "Active"
      }
      type <- CreateQualificationType(name = name, description = description,
                                      keywords = keywords, status = status, retry.delay = retry.delay,
                                      test = test, answerkey = answerkey, test.duration = test.duration,
                                      auto = auto, auto.value = auto.value)
      qual <- as.character(type$QualificationTypeId)
    }

    qual.value <- value
    Qualifications <- emptydf(length(workers), 5,
                              c("WorkerId", "QualificationTypeId", "Value", "Notified", "Valid"))

    for (i in 1:length(workers)) {
      x <- batch(workers[i], value[i])
      if (is.null(x$valid)) {
        x$valid <- FALSE
      }
      Qualifications[i, ] = c(workers[i], qual, value[i], notify, x$valid)
    }

    Qualifications$Valid <- factor(Qualifications$Valid, levels=c('TRUE','FALSE'))
    return(Qualifications)
  }

