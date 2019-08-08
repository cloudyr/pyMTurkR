#' Create HIT
#'
#' Create a single HIT. This is the most important function in the package. It
#' creates a HIT based upon the specified parameters: (1) characteristics
#' inherited from a HITType or specification of those parameters and (2) some
#' kind of Question data structure. Use \code{\link{BulkCreate}} to create
#' multiple HITs with shared properties.
#'
#' This function creates a new HIT and makes it available to workers.
#' Characteristics of the HIT can either be specified by including a valid
#' HITTypeId for \dQuote{hit.type} or creating a new HITType by atomically
#' specifying the characteristics of a new HITType.
#'
#' When creating a HIT, some kind of Question data structure must be specified.
#' Either, a QuestionForm, HTMLQuestion, or ExternalQuestion data structure can
#' be specified for the \code{question} parameter or, if a HIT template created
#' in the Requester User Interface (RUI) is being used, the appropriate
#' \code{hitlayoutid} can be specified. If the HIT template contains variable
#' placeholders, then the \code{hitlayoutparameters} should also be specified.
#'
#' When creating a ExternalQuestion HITs, the
#' \code{\link{GenerateHITsFromTemplate}} function can emulate the HIT template
#' functionality by converting a template .html file into a set of individual
#' HIT .html files (that would also have to be uploaded to a web server) and
#' executing \code{CreateHIT} for each of these external files with an
#' appropriate ExternalQuestion data structure specified for the
#' \code{question} parameter.
#'
#' Note that HIT and Assignment Review Policies are not currently supported.
#'
#' \code{createhit()}, \code{create()}, \code{create_hit()},
#' \code{CreateHITWithHITType()}, \code{create_hit_with_hit_type()} are aliases.
#'
#' @aliases CreateHIT createhit create create_hit CreateHITWithHITType
#' create_hit_with_hit_type
#' @param hit.type An optional character string specifying the HITTypeId that
#' this HIT should be generated from. If used, the HIT will inherit title,
#' description, keywords, reward, and other properties of the HIT.
#' @param question A mandatory (unless layoutid is specified) character string
#' containing a QuestionForm, HTMLQuestion, or ExternalQuestion data structure.
#' In lieu of a question parameter, a \code{hitlayoutid} and, optionally,
#' \code{hitlayoutparameters} can be specified.
#' @param expiration The time (in seconds) that the HIT should be available to
#' workers. Must be between 30 and 31536000 seconds.
#' @param assignments A character string specifying the number of assignments
#' @param assignment.review.policy An optional character string containing an
#' Assignment-level ReviewPolicy data structure as returned by \code{\link{GenerateAssignmentReviewPolicy}}.
#' @param hit.review.policy An optional character string containing a HIT-level
#' ReviewPolicy data structure as returned by \code{\link{GenerateHITReviewPolicy}}.
#' @param annotation An optional character string annotating the HIT. This is
#' not visible to workers, but can be used as a label by which to identify the
#' HIT from the API.
#' @param unique.request.token An optional character string, included only for
#' advanced users. It can be used to prevent creating a duplicate HIT. A HIT
#' will not be creatd if a HIT was previously granted (within a short time
#' window) using the same \code{unique.request.token}.
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
#' @param hitlayoutid An optional character string including a HITLayoutId
#' retrieved from a HIT \dQuote{project} template generated in the Requester
#' User Interface at \samp{https://requester.mturk.com/create/projects}. If the
#' HIT template includes variable placeholders, must also specify
#' \code{hitlayoutparameters}.
#' @return A data frame containing the HITId and other details of the newly
#' created HIT.
#' @author Tyler Burleigh, Thomas J. Leeper
#' @references
#' \href{https://docs.aws.amazon.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_CreateHITOperation.html}{API Reference}
#' @keywords HITs
#' @examples
#'
#' \dontrun{
#'
#' CreateHIT(title = "Survey",
#'          description = "5 question survey",
#'          reward = "0.10",
#'          assignments = 1,
#'          expiration = seconds(days = 4),
#'          duration = seconds(hours = 1),
#'          keywords = "survey, questionnaire",
#'          question = GenerateExternalQuestion("https://www.example.com/","400"))
#' }
#'

CreateHIT <-
  CreateHITWithHITType <-
  create <-
  createhit <-
  createhitwithhittype <-
  function (hit.type = NULL, question = NULL, expiration, assignments = NULL,
            assignment.review.policy = NULL, hit.review.policy = NULL,
            annotation = NULL, unique.request.token = NULL, title = NULL,
            description = NULL, reward = NULL, duration = NULL, keywords = NULL,
            auto.approval.delay = NULL, qual.req = NULL, hitlayoutid = NULL,
            verbose = getOption('pyMTurkR.verbose', TRUE)) {

    client <- GetClient() # Boto3 client

    # List to store arguments
    args <- list()

    if (!is.null(hit.type)) {
      if (is.factor(hit.type)) {
        hit.type <- as.character(hit.type)
      }
      if ( (!is.null(title) || !is.null(description) ||
            !is.null(reward) || !is.null(duration)) & verbose) {
        warning("HITType specified, HITType parameters (title, description, reward, duration) ignored")
      }

      # Set the function to use later (this one has a hit type)
      fun <- client$create_hit_with_hit_type

      # Add to args list
      args <- c(args, list(HITTypeId = hit.type))

      # Assignments, if specified
      if(!is.null(assignments)) {
        if (as.integer(assignments) < 1 | as.integer(assignments) > 1e+09) {
          stop("MaxAssignments must be between 1 and 1000000000")
        } else {

          args <- c(args, list(MaxAssignments = as.integer(assignments)))
        }
      }

    } else { # No hit.type specified, use other params
      if (is.null(title) || is.null(description) || is.null(reward) || is.null(duration)) {
        stop("Must specify HITType xor HITType parameters (title, description, reward, duration)")
      } else { # Use other params

        # Set the function to use later (this one doesn't have a hit type)
        fun <- client$create_hit

        # Title
        if (nchar(title) > 128) {
          stop("Title too long (128 char max)")
        } else {
          args <- c(args, list(Title = as.character(title)))
        }

        # Description
        if (nchar(description) > 2000) {
          stop("Description too long (2000 char max)")
        } else {
          args <- c(args, list(Description = as.character(description)))
        }

        # Duration
        if (as.numeric(duration) < 30 || as.numeric(duration) > 3153600) {
          stop("Duration must be between 30 (30 seconds) and 3153600 (365 days)")
        } else {
          args <- c(args, list(AssignmentDurationInSeconds = as.integer(duration)))
        }

        # Rewards
        if (is.null(reward)) {
          stop("Reward must be set")
        } else {
          # If it's a fraction of a dollar, then it must have a leading zero
          if(grepl('^\\.', reward)){
            reward <- paste0('0', reward)
          }
          args <- c(args, list(Reward = as.character(reward)))
        }

        # Keywords
        if (!is.null(keywords)) {
          if (nchar(keywords) > 1000) {
            stop("Keywords too long (1000 char max)")
          } else {
            args <- c(args, list(Keywords = as.character(keywords)))
          }
        }

        # Assignments
        if (is.null(assignments)) {
          stop("Number of Assignments must be specified")
        } else if (as.integer(assignments) < 1 | as.integer(assignments) > 1e+09) {
          stop("MaxAssignments must be between 1 and 1000000000")
        } else {
          args <- c(args, list(MaxAssignments = as.integer(assignments)))
        }

      }
    }

    # Common to both methods

    # Must contain one of: QuestionForm, HTMLQuestion,
    #   ExternalQuestion for 'question' parameter; or a 'hitlayoutid'
    if (is.null(question)) {
      if (!is.null(hitlayoutid)) {
        args <- c(args, list(HITLayoutId = as.character(hitlayoutid)))
      } else {
        stop("Must specify QuestionForm, HTMLQuestion, or ExternalQuestion for 'question' parameter; or a 'hitlayoutid'")
      }
    } else {
      if (class(question) %in% c('HTMLQuestion','ExternalQuestion')) {
        question <- question$string
      }
      args <- c(args, list(Question = as.character(question)))
    }

    # Expiration
    if (is.null(expiration)) {
      stop("Must specify HIT LifetimeInSeconds for expiration parameter")
    } else if (as.integer(expiration) < 30 | as.integer(expiration) > 31536000) {
      stop("HIT LifetimeInSeconds/expiration must be between 30 and 31536000 seconds")
    } else {
      args <- c(args, list(LifetimeInSeconds = as.integer(expiration)))
    }

    # Annotation
    if (!is.null(annotation) && nchar(annotation) > 255) {
      stop("Annotation must be <= 255 characters")
    } else if (!is.null(annotation)) {
      args <- c(args, list(RequesterAnnotation = as.character(annotation)))
    }

    # Assignment review policy
    if (!is.null(assignment.review.policy)) {
      args <- c(args, list(AssignmentReviewPolicy = assignment.review.policy))
    }

    # HIT review policy
    if (!is.null(hit.review.policy)) {
      args <- c(args, list(HITReviewPolicy = hit.review.policy))
    }

    # Unique request token
    if (!is.null(unique.request.token) && nchar(curl_escape(unique.request.token)) > 64) {
      stop("UniqueRequestToken must be <= 64 characters")
    } else if (!is.null(unique.request.token)) {
      args <- c(args, list(UniqueRequestToken = as.character(unique.request.token)))
    }

    # Qualification Requirements
    if (!is.null(qual.req)){
      args <- c(args, list(QualificationRequirements = qual.req))
    }

    # Execute the API call
    response <- try(
      do.call('fun', args)
    )

    # Validity check
    if(class(response) == "try-error") {
      warning("Invalid Request")
    } else {
      HITs <- emptydf(1, 3, c("HITTypeId", "HITId", "Valid"))
      HITs$HITTypeId <- response$HIT$HITTypeId
      HITs$HITId <- response$HIT$HITId
      HITs$Valid <- TRUE

      message("HIT ", response$HIT$HITId, " created")
      return(HITs)
    }

  }

