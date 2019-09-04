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
#' \code{changehittype()} and \code{UpdateHITTypeOfHIT()} are aliases.
#'
#' @aliases ChangeHITType changehittype UpdateHITTypeOfHIT
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
#' standard output. Default is taken from \code{getOption('pyMTurkR.verbose',
#' TRUE)}.
#' @return A data frame listing the HITId of each HIT who HITType was changed,
#' its old HITTypeId and new HITTypeId, and whether the request for each HIT
#' was valid.
#' @author Tyler Burleigh, Thomas J. Leeper
#' @seealso \code{\link{CreateHIT}}
#'
#' \code{\link{RegisterHITType}}
#' @references
#' \href{http://docs.amazonwebservices.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_ChangeHITTypeOfHITOperation.html}{API
#' Reference}
#' @keywords HITs
#' @examples
#'
#' \dontrun{
#' hittype1 <- RegisterHITType(title = "10 Question Survey",
#'                 description = "Complete a 10-question survey about news coverage and your opinions",
#'                 reward = ".20",
#'                 duration = seconds(hours=1),
#'                 keywords = "survey, questionnaire, politics")
#' a <- GenerateExternalQuestion("https://www.example.com/", "400")
#' hit <- CreateHIT(hit.type = hittype1$HITTypeId,
#'                  assignments = 1,
#'                  expiration = seconds(days=1),
#'                  question = a$string)
#'
#' # change to HITType with new reward amount
#' hittype2 <- RegisterHITType(title = "10 Question Survey",
#'                 description = "Complete a 10-question survey about news coverage and your opinions",
#'                 reward = ".45",
#'                 duration = seconds(hours=1),
#'                 keywords = "survey, questionnaire, politics")
#' ChangeHITType(hit = hit$HITId,
#'               new.hit.type=hittype2$HITTypeId)
#'
#' # Change to new HITType, with arguments stated atomically
#' ChangeHITType(hit = hit$HITId,
#'               title = "10 Question Survey",
#'               description = "Complete a 10-question survey about news coverage and your opinions",
#'               reward = ".20",
#'               duration = seconds(hours=1),
#'               keywords = "survey, questionnaire, politics")
#'
#' # expire and dispose HIT
#' ExpireHIT(hit = hit$HITId)
#' DeleteHIT(hit = hit$HITId)
#' }
#'
#' @export ChangeHITType
#' @export changehittype
#' @export UpdateHITTypeOfHIT


ChangeHITType <-
  changehittype <-
  UpdateHITTypeOfHIT <-
  function (hit = NULL,
            old.hit.type = NULL,
            new.hit.type = NULL,
            title = NULL,
            description = NULL,
            reward = NULL,
            duration = NULL,
            keywords = NULL,
            auto.approval.delay = as.integer(2592000),
            qual.req = NULL,
            old.annotation = NULL,
            verbose = getOption('pyMTurkR.verbose', TRUE)) {

    GetClient() # Boto3 client

    # Make sure the function call is specifying only one of hit, old.hit.type,
    # old.annotation
    if (
      !(
        (!is.null(hit) & is.null(old.hit.type) & is.null(old.annotation)) |
        (is.null(hit) & !is.null(old.hit.type) & is.null(old.annotation)) |
        (is.null(hit) & is.null(old.hit.type) & !is.null(old.annotation))
      )
    ) {
      stop("Must provide 'hit' xor 'old.hit.type' xor 'old.annotation'")
    }

    if (is.factor(hit)) {
      hit <- as.character(hit)
    }

    # If a new HIT Type is specified, then new HIT details should not be
    if (!is.null(new.hit.type)) {
      if (!is.null(new.hit.type) & (!is.null(title) ||
                                    !is.null(description) ||
                                    !is.null(reward) ||
                                    !is.null(duration))) {
        warning("HITType specified, HITType parameters (title, description, reward, duration) ignored")
      }
    } else { # If new HIT Type is not specified, then new HIT details should also be specified
      if (is.null(title) || is.null(description) || is.null(reward) || is.null(duration))  {
        stop("Must specify new HITType xor new HITType parameters (title, description, reward, duration)")
      } else {
        # Create a new HIT Type for the user
        register <- try(RegisterHITType(title = title,
                                        description = description,
                                        reward = reward,
                                        duration = duration,
                                        keywords = keywords,
                                        auto.approval.delay = auto.approval.delay,
                                        qual.req = qual.req), silent = !verbose)

        if (class(register) == "try-error") {
          stop("Could not RegisterHITType(), check parameters")
        } else {
          new.hit.type <- register$HITTypeId
        }
      }
    }

    # We need hit, old.hit.type, or old.annotation
    if (!is.null(hit)) { # hit
      hitlist <- hit
    } else if(!is.null(old.hit.type)) { # old.hit.type
      if (is.factor(old.hit.type)) {
        old.hit.type <- as.character(old.hit.type)
      }
      message("Hang on while I search your HITs by HIT Type ID...")
      hitsearch <- SearchHITs(verbose = FALSE)
      hitlist <- hitsearch$HITs$HITId[hitsearch$HITs$HITTypeId %in% old.hit.type]
    } else if (!is.null(old.annotation)) { # old.annotation
      if (is.factor(old.annotation)) {
        old.annotation <- as.character(old.annotation)
      }
      message("Hang on while I search your HITs by annotation...")
      hitsearch <- SearchHITs(verbose = FALSE)
      hitlist <- hitsearch$HITs$HITId[grepl(old.annotation, hitsearch$HITs$RequesterAnnotation)]
    }
    if (length(hitlist) == 0) {
      stop("No HITs found for HITType")
    }

    # Initialize empty df for return
    HITs <- emptydf(length(hitlist), 4, c("HITId", "oldHITTypeId", "newHITTypeId", "Valid"))

    # Loop through list of HITs and change the type
    for (i in 1:length(hitlist)) {

      hit <- hitlist[i]
      response <- try(.pyMTurkRClient$update_hit_type_of_hit(
        HITId = hit,
        HITTypeId = new.hit.type
      ), silent = !verbose)

      if (class(response) != "try-error") { # Valid
        valid <- TRUE
      } else {
        valid <- FALSE
      }

      if (is.null(old.hit.type)) {
        HITs[i, ] <- c(hitlist[i], NA, new.hit.type, valid)
      } else {
        HITs[i, ] <- c(hitlist[i], old.hit.type, new.hit.type, valid)
      }

      if (verbose) {
        if (valid) {
          message(i, ": HITType of HIT ", hitlist[i], " Changed to: ", new.hit.type)
        } else {
          warning(i,": Invalid Request for HIT ", hitlist[i])
        }
      }
    }

    HITs$Valid <- factor(HITs$Valid, levels=c('TRUE','FALSE'))
    return(HITs)
  }
