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
          description = '',
          status,
          keywords = '',
          retry.delay = NULL,
          test = NULL,
          answerkey = NULL,
          test.duration = NULL,
          auto = NULL,
          auto.value = NULL,
          sandbox = TRUE,
          profile = 'default') {

  client <- GetClient(sandbox, profile) # Boto3 client

  # Check status is valid
  if(!status %in% c("Active", "Inactive"))
    stop("QualificationTypeStatus must be Active or Inactive")

  # Create Qualification
  response <- try(client$create_qualification_type(
    Name = name,
    Description = description,
    Keywords = keywords,
    QualificationTypeStatus = status
  ), silent = TRUE)

  # Update Qualification with any other parameters,
  # but only if we've just created it
  if(class(response) == "try-error") stop("A Qualfication with this name already exists.")
  else {

    qual <- response$QualificationType$QualificationTypeId

    # Add Test
    if(!is.null(test) & !is.null(test.duration)) .helper_createqual_add_test(client, qual, test, test.duration)

    # Add AnswerKey
    if(!is.null(test) &
       !is.null(answerkey) &
       !is.null(test.duration)) .helper_createqual_add_answerkey(client, qual, answerkey, test, test.duration)

    # Add AutoGranted
    if(!is.null(auto) & !is.null(auto.value) & is.null(test)) .helper_createqual_add_auto(client, qual, auto, auto.value)

    # Add RetryDelay
    if(!is.null(retry.delay)) .helper_createqual_add_retry(client, qual, retry.delay)

    # Return stuff
    message("QualificationType Created: ", qual)
    invisible(.helper_createqual_get_qual_info(client, qual))

  }

}

.helper_createqual_add_test <-
function(client, qual, test, test.duration) {
  client$update_qualification_type(
    QualificationTypeId = qual,
    Test = test,
    TestDurationInSeconds = as.integer(test.duration)
  )
}

.helper_createqual_add_answerkey <-
function(client, qual, answerkey, test, test.duration){
  client$update_qualification_type(
    QualificationTypeId = qual,
    AnswerKey = answerkey,
    Test = test,
    TestDurationInSeconds = as.integer(test.duration)
  )
}

.helper_createqual_add_auto <-
  function(client, qual, auto, auto.value){
    print(auto)
    client$update_qualification_type(
      QualificationTypeId = qual,
      AutoGranted = as.logical(auto),
      AutoGrantedValue = as.integer(auto.value)
    )
}

.helper_createqual_add_retry <-
  function(client, qual, answerkey, retry.delay){
    client$update_qualification_type(
      QualificationTypeId = qual,
      RetryDelayInSeconds = as.integer(test.duration)
    )
  }

.helper_createqual_get_qual_info <-
  function(client, qual){

    response <- client$get_qualification_type(
      QualificationTypeId = qual
    )

    info <- emptydf(0, 13, c("QualificationTypeId", "CreationTime", "Name", "Description", "Keywords",
                             "QualificationTypeStatus", "AutoGranted", "AutoGrantedValue", "IsRequestable",
                             "RetryDelayInSeconds", "TestDurationInSeconds", "Test", "AnswerKey"))

    info[1,]$QualificationTypeId <- response$QualificationType$QualificationTypeId
    info[1,]$CreationTime <- reticulate::py_to_r(response$QualificationType$CreationTime)
    info[1,]$Name <- response$QualificationType$Name
    info[1,]$Description <- response$QualificationType$Description
    info[1,]$Keywords <- response$QualificationType$Keywords
    info[1,]$QualificationTypeStatus <- response$QualificationType$QualificationTypeStatus
    info[1,]$AutoGranted <- response$QualificationType$AutoGranted
    info[1,]$AutoGrantedValue <- response$QualificationType$AutoGrantedValue
    info[1,]$IsRequestable <- response$QualificationType$IsRequestable
    info[1,]$RetryDelayInSeconds <- response$QualificationType$RetryDelayInSeconds
    info[1,]$TestDurationInSeconds <- response$QualificationType$TestDurationInSeconds
    info[1,]$Test <- response$QualificationType$Test
    info[1,]$AnswerKey <- response$QualificationType$AnswerKey

    info
}
