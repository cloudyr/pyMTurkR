#' Get Assignment(s)
#'
#' Get an assignment or multiple assignments for one or more HITs (or a
#' HITType) as a data frame.
#'
#' This function returns the requested assignments. The function must specify
#' an AssignmentId xor a HITId xor a HITTypeId. If an AssignmentId is
#' specified, only that assignment is returned. If a HIT or HITType is
#' specified, default behavior is to return all assignments through a series of
#' sequential (but invisible) API calls meaning that returning large numbers of
#' assignments (or assignments for a large number of HITs in a single request)
#' may be time consuming.
#'
#' \code{GetAssignments()}, \code{assignment()}, \code{assignments()},
#' and \code{ListAssignmentsForHIT()} are aliases.
#'
#' @aliases GetAssignment GetAssignments assignment assignments ListAssignmentsForHIT
#' @param assignment An optional character string specifying the AssignmentId
#' of an assignment to return. Must specify \code{assignment} xor \code{hit}
#' xor \code{hit.type} xor \code{annotation}.
#' @param hit An optional character string specifying the HITId whose
#' assignments are to be returned, or a vector of character strings specifying
#' multiple HITIds all of whose assignments are to be returned. Must specify
#' \code{assignment} xor \code{hit} xor \code{hit.type} xor \code{annotation}.
#' @param hit.type An optional character string specifying the HITTypeId (or a
#' vector of HITTypeIds) of one or more HITs whose assignments are to be
#' returned. Must specify \code{assignment} xor \code{hit} xor \code{hit.type}
#' xor \code{annotation}.
#' @param annotation An optional character string specifying the value of the
#' \code{RequesterAnnotation} field for a batch of HITs. This can be used to
#' retrieve all assignments for all HITs from a \dQuote{batch} created in the
#' online Requester User Interface (RUI). To use a batch ID, the batch must be
#' written in a character string of the form \dQuote{BatchId:78382;}, where
#' \dQuote{73832} is the batch ID shown in the RUI. Must specify
#' \code{assignment} xor \code{hit} xor \code{hit.type} xor \code{annotation}.
#' @param status An optional vector of character strings (containing one of more of
#' \dQuote{Approved},\dQuote{Rejected},\dQuote{Submitted}), specifying whether
#' only a subset of assignments should be returned. If \code{NULL}, all
#' assignments are returned (the default). Only applies when \code{hit} or
#' \code{hit.type} are specified; ignored otherwise.
#' @param return.pages An integer indicating how many pages of results should
#' be returned.
#' @param pagetoken An optional character string indicating which page of
#' search results to start at. Most users can ignore this.
#' @param results An optional character string indicating how many results to
#' fetch per page. Must be between 1 and 100. Most users can ignore this.
#' @param answers.as.separate.df An optional logical indicating whether the
#' assignment answers should be returned in a separate data frame, or as a
#' column in the Assignments data frame. Defaults to FALSE.
#' @param verbose Optionally print the results of the API request to the
#' standard output. Default is taken from \code{getOption('pyMTurkR.verbose',
#' TRUE)}.
#' @return Optionally a data frame containing Assignment data, including
#' workers responses to any questions specified in the \code{question}
#' parameter of the \code{CreateHIT} function.
#' @author Tyler Burleigh, Thomas J. Leeper
#' @references
#' \href{https://docs.aws.amazon.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_GetAssignmentOperation.html}{API
#' Reference: GetAssignment}
#'
#' \href{https://docs.aws.amazon.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_ListAssignmentsForHITOperation.html}{API Reference: ListAssignmentsForHIT}
#' @keywords Assignments
#' @examples
#'
#' \dontrun{
#' # get an assignment
#' GetAssignment(assignments = "26XXH0JPPSI23H54YVG7BKLEXAMPLE")
#' # get all assignments for a HIT
#' GetAssignment(hit = "2MQB727M0IGF304GJ16S1F4VE3AYDQ")
#' # get all assignments for a HITType
#' GetAssignment(hit.type = "2FFNCWYB49F9BBJWA4SJUNST5OFSOW")
#' # get all assignments for an online batch from the RUI
#' GetAssignment(annotation="BatchId:78382;")
#' }
#'

GetAssignment <-
  assignment <-
  assignments <-
  GetAssignments <-
  ListAssignmentsForHIT <-
  function(assignment = NULL,
           hit = NULL,
           hit.type = NULL,
           annotation = NULL,
           status = NULL,
           return.pages = NULL,
           results = as.integer(100),
           pagetoken = NULL,
           answers.as.separate.df = FALSE,
           verbose = getOption('pyMTurkR.verbose', TRUE)) {

    client <- GetClient() # Boto3 client

    if (as.numeric(results) < 1 || as.numeric(results) > 100) {
      stop("'pagesize' must be in range (1 to 100)")
    }

    # Check that one of the params for lookup was provided
    if (all(is.null(assignment) & is.null(hit) & is.null(hit.type) & is.null(annotation))) {
      stop("Must provide 'assignment' xor 'hit' xor 'hit.type' xor 'annotation'")
    } else if (!is.null(assignment)) { # Lookup by assignments

      # For each assignment...
      for (i in 1:length(assignment)) {
        response <- try(client$get_assignment(AssignmentId = assignment[i]))
        QualificationRequirements <- list()
        if (class(response) != "try-error") {
          tmp <- as.data.frame.Assignment(response$Assignment)
          a <- tmp$assignments
          ans <- tmp$answers
          if (i == 1) {
            Assignments <- a
            Answers <- ans
          } else {
            Assignments <- rbind(Assignments, a, all=TRUE)
            Answers <- rbind(Answers, ans, all=TRUE)
          }
          if (verbose) {
            message(i, ": Assignment ", assignment[i], " Retrieved")
          }
        }
      }
      return(list(Assignments = Assignments, Answers = Answers))


    } else { # Search for HITs that match criteria given
      if (!is.null(hit)) { # First we need to get a list of HITs
        if (is.factor(hit)) {
          hit <- as.character(hit)
        }
        hitlist <- hit
      } else if (!is.null(hit.type)) { # Search by HIT Type
        if (is.factor(hit.type)) {
          hit.type <- as.character(hit.type)
        }
        message("Searching for HITs matching HITTypeId...")
        hitsearch <- SearchHITs()
        hitlist <- hitsearch$HITs$HITId[hitsearch$HITs$HITTypeId %in% hit.type]
      } else if (!is.null(annotation)) { # Search by HIT Annotation
        if (is.factor(annotation)) {
          annotation <- as.character(annotation)
        }
        hitsearch <- SearchHITs()
        hitlist <- hitsearch$HITs$HITId[grepl(annotation, hitsearch$HITs$RequesterAnnotation)]
      }
      if (length(hitlist) == 0) {
        stop("No HITs found for HITType")
      }

      if (!is.null(status)) {
        if (!all(status %in% c("Approved", "Rejected", "Submitted"))) {
          stop("Status must be vector containing one or more of: 'Approved', 'Rejected', 'Submitted'")
        }
      } else {
        status <- c("Approved", "Rejected", "Submitted")
      }

      batch_helper_list_assignments <- function(batchhit, pagetoken = NULL, num_retries = 1) {

        if(!is.null(pagetoken)){ # Use page token if given
          response <- try(client$list_assignments_for_hit(HITId = batchhit,
                                                           NextToken = pagetoken,
                                                           MaxResults = as.integer(results),
                                                           AssignmentStatuses = as.list(status)))
        } else {
          response <- try(client$list_assignments_for_hit(HITId = batchhit,
                                                           MaxResults = as.integer(results),
                                                           AssignmentStatuses = as.list(status)))
        }

        # Validity check response
        if(class(response) == "try-error") {
          # If the response was an error, then we should try again
          # but stop after 5 attempts
          message("  Error. Trying again. Attempt #", num_retries, " for HIT: ", batchhit)
          message("  Waiting a few seconds before retrying...")
          Sys.sleep(5)
          num_retries <- num_retries + 1
          response <- batch_helper_list_assignments(batchhit = batchhit,
                                                    pagetoken = pagetoken,
                                                    num_retries = num_retries)
          if(num_retries >= 5){
            stop(paste0("Failed after 5 attempts to fetch list of assignments for HIT: ", batchhit))
          }
        } else {
          return(response)
        }

      }


      # Batch process function
      batch <- function(batchhit, pagetoken = NULL) {

        response <- batch_helper_list_assignments(batchhit = batchhit, pagetoken = pagetoken)
        assignments <- response$Assignments
        tmpAssignments <- NULL
        tmpAnswers <- NULL

        # For each assignment...
        if(length(assignments) > 0){
          for (i in 1:length(assignments)) {
            tmp <- as.data.frame.Assignment(assignments[[i]])
            tmpAssignments <- rbind(tmpAssignments, tmp$assignments)
            tmpAnswers <- rbind(tmpAnswers, tmp$answers)
            message("\nAssignment ", assignments[[i]]$AssignmentId, " Retrieved")
          }
        } else {
          return(NULL)
        }

        # Update page token
        if(!is.null(response$NextToken)){
          pagetoken <- response$NextToken
        }
        # Update page token
        if(!is.null(response$NumResults)){
          numresults <- response$NumResults
        } else {
          numresults <- 0
        }

        return(list(Assignments = tmpAssignments,
                    Answers = tmpAnswers,
                    NumResults = numresults,
                    NextToken = pagetoken))

      }


      # Keep a running total of all Assignments fetched
      runningtotal <- 0

      Assignments <- emptydf(nrow = 0, ncol = 11, c('AssignmentId', 'WorkerId', 'HITId',
                                                    'AssignmentStatus', 'AutoApprovalTime',
                                                    'AcceptTime', 'SubmitTime', 'ApprovalTime',
                                                    'RejectionTime', 'RequesterFeedback',
                                                    'Answer'))

      Answers <- emptydf(0, 9, c("AssignmentId", "WorkerId", "HITId", "QuestionIdentifier",
                                "FreeText", "SelectionIdentifier", "OtherSelectionField",
                                "UploadedFileKey", "UploadedFileSizeInBytes"))

      # Progress bar because this can take a while
      pb <- progress::progress_bar$new(total = length(hitlist))
      message("\nSearching for Assignments...")

      # Run batch over hitlist
      for (i in 1:length(hitlist)) {

        hit <- hitlist[i]
        pagetoken <- NULL
        results.found <- NULL
        pages <- 1

        while ((is.null(results.found) || results.found == results) &
               (is.null(return.pages) || pages < return.pages)) {

          response <- batch(hit, pagetoken)
          results.found <- response$NumResults
          to.return <- response

          # Update if response found results
          if(!is.null(response)) {
            runningtotal <- runningtotal + response$NumResults
            results.found <- response$NumResults
            pagetoken <- response$NextToken
          } else {
            results.found <- 0
          }

          pages <- pages + 1
          Assignments <- rbind(Assignments, to.return$Assignments)
          Answers <- rbind(Answers, to.return$Answers)

        }
        pb$tick()

      }

    }

    if (verbose) {
      message("\n", runningtotal, " Assignments Retrieved")
    }
    if(answers.as.separate.df == TRUE){
      Assignments$Answer <- NULL
      return(list(Assignments = Assignments, Answers = Answers))
    } else {
      for(i in 1:nrow(Assignments)){
        Assignments[i,]$Answer <- list(XML::xmlToList(Assignments[i,]$Answer))
      }
      return(Assignments)
    }

  }
