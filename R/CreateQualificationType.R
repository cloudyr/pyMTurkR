#' Create QualificationType
#'
#' Create a QualificationType. This creates a QualificationType, but does not
#' assign it to any workers. All characteristics of the QualificationType
#' (except name and keywords) can be changed later with
#' \code{\link{UpdateQualificationType}}.
#'
#' A function to create a QualificationType. Active QualificationTypes are
#' visible to workers and to other requesters. All characteristics of the
#' QualificationType, other than the name and keywords, can later be modified
#' by \code{\link{UpdateQualificationType}}. Qualifications can then be used to
#' assign Qualifications to workers with \code{\link{AssignQualification}} and
#' invoked as QualificationRequirements in \code{\link{RegisterHITType}} and/or
#' \code{\link{CreateHIT}} operations.
#'
#' \code{createqual()} and\code{create_qualification_type()}
#' are aliases for \code{CreateQualificationType}.
#'
#' @aliases CreateQualificationType createqual create_qualification_type
#' @param name A name for the QualificationType. This is visible to workers. It
#' cannot be modified by \code{\link{UpdateQualificationType}}.
#' @param description A longer description of the QualificationType. This is
#' visible to workers. Maximum of 2000 characters.
#' @param status A character vector of \dQuote{Active} or \dQuote{Inactive},
#' indicating whether the QualificationType should be active and visible.
#' @param keywords An optional character string containing a comma-separated
#' set of keywords by which workers can search for the QualificationType.
#' Maximum 1000 characters. These cannot be modified by
#' \code{\link{UpdateQualificationType}}.
#' @param retry.delay An optional time (in seconds) indicating how long workers
#' have to wait before requesting the QualificationType after an initial
#' rejection. If not specified, retries are disabled and Workers can request a
#' Qualification of this type only once, even if the Worker has not been
#' granted the Qualification.
#' @param test An optional character string consisting of a QuestionForm data
#' structure, used as a test a worker must complete before the
#' QualificationType is granted to them.
#' @param answerkey An optional character string consisting of an AnswerKey
#' data structure, used to automatically score the test, perhaps as returned by
#' \code{\link{GenerateAnswerKey}}.
#' @param test.duration An optional time (in seconds) indicating how long
#' workers have to complete the test.
#' @param auto A logical indicating whether the Qualification is automatically
#' granted to workers who request it. Default is \code{NULL} meaning
#' \code{FALSE}.
#' @param auto.value An optional parameter specifying the value that is
#' automatically assigned to workers when they request it (if the Qualification
#' is automatically granted).
#' @param verbose Optionally print the results of the API request to the
#' standard output. Default is taken from \code{getOption('pyMTurkR.verbose',
#' TRUE)}.
#' @return A data frame containing the QualificationTypeId and other details of
#' the newly created QualificationType.
#' @author Tyler Burleigh, Thomas J. Leeper
#' @references
#' \href{http://docs.amazonwebservices.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_CreateQualificationTypeOperation.html}{API
#' Reference}
#' @keywords Qualifications
#' @examples
#'
#' \dontrun{
#' # Create
#' qual1 <- CreateQualificationType(name="Worked for me before",
#'            description="This qualification is for people who have worked for me before",
#'            status = "Active",
#'            keywords = "Worked for me before")
#' DisposeQualificationType(qual1$QualificationTypeId)
#' }
#'

CreateQualificationType <-
  createqual <-
  create_qualification_type <-
  function (name,
            description,
            status,
            keywords = NULL,
            retry.delay = NULL,
            test = NULL,
            answerkey = NULL,
            test.duration = NULL,
            auto = NULL,
            auto.value = NULL,
            verbose = getOption('pyMTurkR.verbose', TRUE)) {

    client <- GetClient() # Boto3 client

    # Check status is valid
    if(!status %in% c("Active", "Inactive"))
      stop("QualificationTypeStatus must be Active or Inactive")

    # List to store arguments
    args <- list()

    # Set the function to use later
    fun <- client$create_qualification_type

    # Add required arguments
    args <- c(args, list(Name = name,
                         Description = description,
                         QualificationTypeStatus = status))

    # Add optional fields
    if(!is.null(keywords)){
      args <- c(args, list(Keywords = keywords))
    }
    if(!is.null(test) & is.null(test.duration)){
      stop("If test is specified then test.duration must be too")
    } else if(is.null(test) & !is.null(test.duration)){
      stop("If test.duration is specified then test must be too")
    } else if(!is.null(test) & !is.null(test.duration)){
      args <- c(args, list(Test = as.integer(test.duration)))
    }
    if(is.null(test) & !is.null(answerkey)){
      stop("If answerkey is specified then test must be too")
    } else if(!is.null(test) & !is.null(test.duration) & !is.null(answerkey)){
      args <- c(args, list(AnswerKey = answerkey))
    }
    if(!is.null(auto)){
      if(is.na(as.logical(auto))){
        stop("auto must be TRUE or FALSE")
      }
      args <- c(args, list(AutoGranted = as.logical(auto)))
    }
    if(!is.null(auto.value)){
      if(is.na(as.integer(auto.value))){
        stop("auto.value must be an integer")
      }
      args <- c(args, list(AutoGrantedValue = as.integer(auto.value)))
    }
    if(!is.null(retry.delay)){
      if(is.na(as.integer(retry.delay)) | as.integer(retry.delay) < 0){
        stop("retry.delay must be a positive integer")
      }
      args <- c(args, list(RetryDelayInSeconds = as.integer(retry.delay)))
    }

    # Execute the API call
    response <- try(
      do.call('fun', args)
    )

    # Update Qualification with any other parameters,
    # but only if we've just created it
    if(class(response) == "try-error") {
      stop("Unable to create qualification")
    } else {

      qualid <- response$QualificationType$QualificationTypeId

      info <- emptydf(0, 13, c("QualificationTypeId", "CreationTime", "Name", "Description", "Keywords",
                               "QualificationTypeStatus", "AutoGranted", "AutoGrantedValue", "IsRequestable",
                               "RetryDelayInSeconds", "TestDurationInSeconds", "Test", "AnswerKey"))

      info[1,]$QualificationTypeId <- response$QualificationType$QualificationTypeId
      info[1,]$CreationTime <- reticulate::py_to_r(response$QualificationType$CreationTime)
      info[1,]$Name <- response$QualificationType$Name
      info[1,]$Description <- response$QualificationType$Description
      if(!is.null(keywords)){
        info[1,]$Keywords <- keywords
      }
      info[1,]$QualificationTypeStatus <- response$QualificationType$QualificationTypeStatus
      info[1,]$AutoGranted <- response$QualificationType$AutoGranted
      if(!is.null(auto.value)){
        info[1,]$AutoGrantedValue <- auto.value
      }
      info[1,]$IsRequestable <- response$QualificationType$IsRequestable
      if(!is.null(retry.delay)){
        info[1,]$RetryDelayInSeconds <- retry.delay
      }
      if(!is.null(test)){
        info[1,]$Test <- test
      }
      if(!is.null(answerkey)){
        info[1,]$AnswerKey <- answerkey
      }
      if(!is.null(test.duration)){
        info[1,]$TestDurationInSeconds <- test.duration
      }

      message("QualificationType Created: ", response$QualificationType$QualificationTypeId)

      return(info)

    }

  }
