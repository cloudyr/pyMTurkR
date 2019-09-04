#' Register a HITType
#'
#' Register a HITType on MTurk, in order to create one or more HITs to show up
#' as a group to workers.
#'
#' All HITs of a given HITType are visibly grouped together for workers and
#' share common properties (e.g., reward amount, QualificationRequirements).
#' This function registers a HITType in the MTurk system, which can then be
#' used when creating individual HITs. If a requester wants to change these
#' properties for a specific HIT, the HIT should be changed to a new HITType
#' (see \code{\link{ChangeHITType}}).
#'
#' \code{hittype()}, \code{CreateHITType()}, and \code{createhittype()}
#' are aliases.
#'
#' @aliases RegisterHITType hittype CreateHITType createhittype
#' @param title A character string containing the title for the HITType. All
#' HITs of this HITType will be visibly grouped to workers according to this
#' title. Maximum of 128 characters.
#' @param description A character string containing a description of the
#' HITType. This is visible to workers. Maximum of 2000 characters.
#' @param reward A character string containing the per-assignment reward
#' amount, in U.S. Dollars (e.g., \dQuote{0.15}).
#' @param duration A character string containing the amount of time workers
#' have to complete an assignment for HITs of this HITType, in seconds (for
#' example, as returned by \code{\link{seconds}}). Minimum of 30 seconds and
#' maximum of 365 days.
#' @param keywords An optional character string containing a comma-separated
#' set of keywords by which workers can search for HITs of this HITType.
#' Maximum of 1000 characters.
#' @param auto.approval.delay An optional character string specifying the
#' amount of time, in seconds (for example, as returned by
#' \code{\link{seconds}}), before a submitted assignment is automatically
#' granted. Maximum of 30 days.
#' @param qual.req An optional character string containing one or more
#' QualificationRequirements data structures, for example as returned by
#' \code{\link{GenerateQualificationRequirement}}.
#' @param verbose Optionally print the results of the API request to the
#' standard output. Default is taken from \code{getOption('pyMTurkR.verbose',
#' TRUE)}.
#' @return A two-column data frame containing the HITTypeId of the newly
#' registered HITType and an indicator for whether the registration request was
#' valid.
#' @author Tyler Burleigh, Thomas J. Leeper
#' @seealso \code{\link{CreateHIT}}
#'
#' \code{\link{ChangeHITType}}
#' @references
#' \href{https://docs.aws.amazon.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_UpdateHITTypeOfHITOperation.html}{API
#' Reference: Operation}
#'
#' @keywords HITs
#' @examples
#'
#' \dontrun{
#' RegisterHITType(title="10 Question Survey",
#'                 description=
#'                 "Complete a 10-question survey about news coverage and your opinions",
#'                 reward=".20",
#'                 duration=seconds(hours=1),
#'                 keywords="survey, questionnaire, politics")
#' }
#'
#' @export RegisterHITType
#' @export hittype
#' @export CreateHITType
#' @export createhittype

RegisterHITType <-
  hittype <-
  CreateHITType <-
  createhittype <-
  function (title,
            description,
            reward,
            duration,
            keywords = NULL,
            auto.approval.delay = as.integer(2592000),
            qual.req = NULL,
            verbose = getOption('pyMTurkR.verbose', TRUE)) {

    GetClient() # Boto3 client

    # Validate fields
    if (nchar(title) > 128) {
      stop("Title too long (128 char max)")
    }
    if (nchar(description) > 2000) {
      stop("Description too long (2000 char max)")
    }
    if (as.numeric(duration) < 30 || as.numeric(duration) > 3153600) {
      stop("Duration must be between 30 (30 seconds) and 3153600 (365 days)")
    } else {
      duration <- as.integer(duration)
    }
    if (!is.null(keywords)) {
      if (nchar(keywords) > 1000) {
        stop("Keywords too long (1000 char max)")
      } else {
        keywords <- ""
      }
    }
    if (!is.null(auto.approval.delay)) {
      if (!as.integer(auto.approval.delay) > 0 | !as.integer(auto.approval.delay) <= 2592000) {
        warning("AutoApprovalDelayInSeconds must be between 0 (0 seconds) and 2592000 (30 days); defaults to 30 days")
        auto.approval.delay <- as.integer(2592000)
      } else {
        auto.approval.delay <- as.integer(auto.approval.delay)
      }
    }

    # Rewards
    # If it's a fraction of a dollar, then it must have a leading zero
    if(grepl('^\\.', reward)){
      reward <- paste0('0', reward)
    }
    args <- c(args, list(Reward = as.character(reward)))

    HITType <- emptydf(1, 2, c("HITTypeId", "Valid"))

    args <- list(AutoApprovalDelayInSeconds = auto.approval.delay,
                  AssignmentDurationInSeconds = duration,
                  Reward = reward,
                  Title = title,
                  Keywords = keywords,
                  Description = description)

    if(!is.null(qual.req)){
      args <- c(args, QualificationRequirements = qual.req)
    }

    fun <- pyMTurkRClient$create_hit_type

    # Execute the API call
    response <- try(
      do.call('fun', args), silent = !verbose
    )

    if (class(response) != "try-error") { # Valid
      HITType[1, ] <- c(response$HITTypeId, TRUE)
      if (verbose) {
        message("HITType Registered: ", HITType$HITTypeId)
      }
    } else {
      HITType[1, ] <- c(NULL, FALSE)
      if (verbose) {
        warning("Invalid Request")
      }
    }
    HITType$Valid <- factor(HITType$Valid, levels=c('TRUE','FALSE'))
    return(HITType)
  }
