#' Change HITType Properties of a HIT
#' 
#' Change the HITType of a HIT from one HITType to another (e.g., to change the
#' title, description, or qualification requirements associated with a HIT).
#' This will cause a HIT to no longer be grouped with HITs of the previous
#' HITType and instead be grouped with those of the new HITType. You cannot
#' change the payment associated with a HIT without expiring the current HIT
#' and creating a new one.
#' 
#' This function changes the HITType of a specified HIT (or multiple specific
#' HITs or all HITs of a specified HITType) to a new HITType.  \code{hit} xor
#' \code{old.hit.type} must be specified. Then, either a new HITTypeId can be
#' specified or a new HITType can be created by atomically by specifying the
#' characteristics of the new HITType.
#' 
#' \code{changehittype()} is an alias.
#' 
#' @aliases ChangeHITType changehittype
#' @param hit An optional character string containing the HITId whose HITTypeId
#' is to be changed, or a vector of character strings containing each of
#' multiple HITIds to be changed. Must specify \code{hit} xor
#' \code{old.hit.type} xor \code{annotation}.
#' @param old.hit.type An optional character string containing the HITTypeId
#' (or a vector of HITTypeIds) whose HITs are to be changed to the new
#' HITTypeId. Must specify \code{hit} xor \code{old.hit.type} xor
#' \code{annotation}.
#' @param new.hit.type An optional character string specifying the new
#' HITTypeId that this HIT should be visibly grouped with (and whose
#' properties, e.g. reward amount, this HIT should inherit).
#' @param title An optional character string containing the title for the
#' HITType. All HITs of this HITType will be visibly grouped to workers
#' according to this title.
#' @param description An optional character string containing a description of
#' the HITType. This is visible to workers.
#' @param reward An optional character string containing the per-assignment
#' reward amount, in U.S. Dollars (e.g., \dQuote{0.15}).
#' @param duration An optional character string containing the duration of each
#' HIT, in seconds (for example, as returned by \code{\link{seconds}}).
#' @param keywords An optional character string containing a comma-separated
#' set of keywords by which workers can search for HITs of this HITType.
#' @param auto.approval.delay An optional character string specifying the
#' amount of time, in seconds (for example, as returned by
#' \code{\link{seconds}}), before a submitted assignment is automatically
#' granted.
#' @param qual.req An optional character string containing one a
#' QualificationRequirement data structure, as returned by
#' \code{\link{GenerateQualificationRequirement}}.
#' @param old.annotation An optional character string specifying the value of
#' the \code{RequesterAnnotation} field for a batch of HITs to change the
#' HITType of. This can be used to change the HITType for all HITs from a
#' \dQuote{batch} created in the online Requester User Interface (RUI). To use
#' a batch ID, the batch must be written in a character string of the form
#' \dQuote{BatchId:78382;}, where \dQuote{73832} is the batch ID shown in the
#' RUI. Must specify \code{hit} xor \code{old.hit.type} xor \code{annotation}.
#' @param verbose Optionally print the results of the API request to the
#' standard output. Default is taken from \code{getOption('MTurkR.verbose',
#' TRUE)}.
#' @param ... Additional arguments passed to \code{\link{request}}.
#' @return A data frame listing the HITId of each HIT who HITType was changed,
#' its old HITTypeId and new HITTypeId, and whether the request for each HIT
#' was valid.
#' @author Thomas J. Leeper
#' @seealso \code{\link{CreateHIT}}
#' 
#' \code{\link{RegisterHITType}}
#' @references
#' \href{http://docs.amazonwebservices.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_ChangeHITTypeOfHITOperation.htmlAPI
#' Reference}
#' @keywords HITs
#' @examples
#' 
#' \dontrun{
#' hittype1 <- 
#' RegisterHITType(title = "10 Question Survey",
#'                 description =
#'                   "Complete a 10-question survey about news coverage and your opinions",
#'                 reward = ".20", 
#'                 duration = seconds(hours=1), 
#'                 keywords = "survey, questionnaire, politics")
#' a <- GenerateExternalQuestion("http://www.example.com/", "400")
#' hit <- CreateHIT(hit.type = hittype1$HITTypeId, 
#'                  assignments = 1,
#'                  expiration = seconds(days=1),
#'                  question = a$string)
#' 
#' # change to HITType with new reward amount
#' hittype2 <- 
#' RegisterHITType(title = "10 Question Survey",
#'                 description =
#'                   "Complete a 10-question survey about news coverage and your opinions",
#'                 reward = ".45", 
#'                 duration = seconds(hours=1), 
#'                 keywords = "survey, questionnaire, politics")
#' ChangeHITType(hit = hit$HITId,
#'               new.hit.type=hittype2$HITTypeId)
#' 
#' # Change to new HITType, with arguments stated atomically
#' ChangeHITType(hit = hit$HITId,
#'               title = "10 Question Survey", 
#'               description =
#'                 "Complete a 10-question survey about news coverage and your opinions", 
#'               reward = ".20", 
#'               duration = seconds(hours=1), 
#'               keywords = "survey, questionnaire, politics")
#' 
#' # expire and dispose HIT
#' ExpireHIT(hit = hit$HITId)
#' DisposeHIT(hit = hit$HITId)
#' }
#' 