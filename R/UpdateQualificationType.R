#' Update a Worker QualificationType
#'
#' Update characteristics of a QualificationType.
#'
#' A function to update the characteristics of a QualificationType. Name and
#' keywords cannot be modified after a QualificationType is created.
#'
#' \code{updatequal()} is an alias.
#'
#' @aliases UpdateQualificationType updatequal
#' @param qual A character string containing a QualificationTypeId.
#' @param description A longer description of the QualificationType. This is
#' visible to workers. Maximum of 2000 characters.
#' @param status A character vector of \dQuote{Active} or \dQuote{Inactive},
#' indicating whether the QualificationType should be active and visible.
#' @param retry.delay An optional time (in seconds) indicating how long workers
#' have to wait before requesting the QualificationType after an initial
#' rejection. If not specified, retries are disabled and Workers can request a
#' Qualification of this type only once, even if the Worker has not been
#' granted the Qualification.
#' @param test An optional character string consisting of a QuestionForm data
#' structure, used as a test a worker must complete before the
#' QualificationType is granted to them.
#' @param answerkey An optional character string consisting of an AnswerKey
#' data structure, used to automatically score the test
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
#' @return A data frame containing the QualificationTypeId of the newly created
#' QualificationType and other details as specified in the request.
#' @author Tyler Burleigh, Thomas J. Leeper
#' @seealso \code{\link{GetQualificationType}}
#'
#' \code{\link{CreateQualificationType}}
#'
#' \code{\link{DisposeQualificationType}}
#'
#' \code{\link{SearchQualificationTypes}}
#' @references
#' \href{http://docs.amazonwebservices.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_UpdateQualificationTypeOperation.html}{API Reference}
#' @keywords Qualifications
#' @examples
#'
#' \dontrun{
#' qual1 <-
#' CreateQualificationType(name="Worked for me before",
#'     description="This qualification is for people who have worked for me before",
#'     status = "Active",
#'     keywords="Worked for me before")
#' qual2 <-
#' UpdateQualificationType(qual1$QualificationTypeId,
#'     description="This qualification is for everybody!",
#'     auto=TRUE, auto.value="5")
#' DisposeQualificationType(qual1$QualificationTypeId)
#' }
#'

UpdateQualificationType <-
updatequal <-
function (qual,
          description = NULL,
          status = NULL,
          retry.delay = NULL,
          test = NULL,
          answerkey = NULL,
          test.duration = NULL,
          auto = NULL,
          auto.value = NULL,
          verbose = getOption('pyMTurkR.verbose', TRUE)) {



  client <- GetClient() # Boto3 client

  # List to store arguments
  args <- list(QualificationTypeId = qual)

  # Set the function to use later
  fun <- client$update_qualification_type

  # Add optional fields
  if(!is.null(description)){
    args <- c(args, list(Description = description))
  }
  if(!is.null(status)){
    args <- c(args, list(QualificationTypeStatus = status))
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
    stop("Unable to update qualification")
  } else {

    info <- emptydf(0, 12, c("QualificationTypeId", "CreationTime", "Name", "Description",
                             "QualificationTypeStatus", "AutoGranted", "AutoGrantedValue", "IsRequestable",
                             "RetryDelayInSeconds", "TestDurationInSeconds", "Test", "AnswerKey"))

    info[1,]$QualificationTypeId <- qual
    info[1,]$CreationTime <- reticulate::py_to_r(response$QualificationType$CreationTime)
    info[1,]$Name <- response$QualificationType$Name
    info[1,]$Description <- response$QualificationType$Description
    if(!is.null(status)){
      info[1,]$QualificationTypeStatus <- status
    }
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

    message("QualificationType updated: ", qual)

    return(info)

  }
}
