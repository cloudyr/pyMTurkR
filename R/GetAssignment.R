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
#' @return Optionally a data frame containing Assignment data, including
#' workers responses to any questions specified in the \code{question}
#' parameter of the \code{CreateHIT} function.
#' @author Tyler Burleigh, Thomas J. Leeper
#' @references
#' \href{https://docs.aws.amazon.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_GetAssignmentOperation.html}{API
#' Reference: GetAssignment}
#'
#' \href{https://docs.aws.amazon.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_ListAssignmentsForHITOperation.html}{API
#' Reference: ListAssignmentsForHIT}
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

assignment <-
  assignments <-
  GetAssignment <-
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
           sandbox = TRUE,
           profile = 'default',
           verbose = TRUE) {

    client <- GetClient(sandbox, profile) # Boto3 client

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
          a <- as.data.frame.Assignment(response$Assignment)$assignments
          a$Answer <- NULL
          if (i == 1) {
            Assignments <- a
          } else {
            Assignments <- rbind(Assignments, a, all=TRUE)
          }
          if (isTRUE(verbose)) {
            message(i, ": Assignment ", assignment[i], " Retrieved")
          }
        }
      }
      return(Assignments)


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
        hitsearch <- SearchHITs(sandbox = sandbox, profile = profile)
        hitlist <- hitsearch$HITs$HITId[hitsearch$HITs$HITTypeId %in% hit.type]
      } else if (!is.null(annotation)) { # Search by HIT Annotation
        if (is.factor(annotation)) {
          annotation <- as.character(annotation)
        }
        hitsearch <- SearchHITs(sandbox = sandbox, profile = profile)
        hitlist <- hitsearch$HITs$HITId[hitsearch$HITs$RequesterAnnotation %in% annotation]
      }
      if (length(hitlist) == 0) {
        stop("No HITs found for HITType")
      }


      # Batch process function
      batch <- function(batchhit, pagetoken = NULL) {

        if (!is.null(status)) {
          if (!all(status %in% c("Approved", "Rejected", "Submitted"))) {
            stop("Status must be vector containing one or more of: 'Approved', 'Rejected', 'Submitted'")
          } else {
            status <- c("Approved", "Rejected", "Submitted")
          }
        } else {
          status <- c("Approved", "Rejected", "Submitted")
        }

        # Use page token if given
        if(!is.null(pagetoken)){
          response1 <- try(client$list_assignments_for_hit(HITId = batchhit,
                                                           NextToken = pagetoken,
                                                           MaxResults = as.integer(results),
                                                           AssignmentStatuses = status))
        } else {
          response1 <- try(client$list_assignments_for_hit(HITId = batchhit,
                                                           MaxResults = as.integer(results),
                                                           AssignmentStatuses = status))
        }

        # Validity check response
        if(class(response) == "try-error") {
          stop(paste0("Failed when trying to fetch list of assignments for HIT: ", batchhit))
        }

        assignments <- response1$Assignments

        # For each assignment...
        for (i in 1:length(assignments)) {
          response2 <- try(client$get_assignment(AssignmentId = assignments[[i]]$AssignmentId))
          QualificationRequirements <- list()
          if (class(response2) != "try-error") {
            a <- as.data.frame.Assignment(response2$Assignment)$assignments
            a$Answer <- NULL
            if (i == 1) {
              Assignments <- a
            } else {
              Assignments <- rbind(Assignments, a)
            }
            if (isTRUE(verbose)) {
              message(i, ": Assignment ", assignments[[i]]$AssignmentId, " Retrieved")
            }
          }
        }
        # Update page token
        if(!is.null(response1$NextToken)){
          pagetoken <- response1$NextToken
        }
        # Update page token
        if(!is.null(response1$NumResults)){
          numresults <- response1$NumResults
        } else {
          numresults <- 0
        }

        return(list(Assignments = Assignments,
                    NumResults = numresults,
                    NextToken = pagetoken))

      }

      # Keep a running total of all Assignments fetched
      runningtotal <- 0
      pages <- 1

      Assignments <- emptydf(nrow = 0, ncol = 10, c('AssignmentId', 'WorkerId', 'HITId',
                                                    'AssignmentStatus', 'AutoApprovalTime',
                                                    'AcceptTime', 'SubmitTime', 'ApprovalTime',
                                                    'RejectionTime', 'RequesterFeedback'))

      # Run batch over hitlist
      for (i in 1:length(hitlist)) {

        response <- batch(hitlist[i])
        results.found <- response$NumResults
        to.return <- response

        # Keep a running total of all HITs returned
        runningtotal <- response$NumResults
        pages <- 1

        while (results.found == results &
               (is.null(return.pages) || pages < return.pages)) {

          # Starting with the next page, identified using NextToken
          pagetoken <- response$NextToken

          # Fetch next batch
          response <- batch(hitlist[i], pagetoken)

          to.return$Assignments <- rbind(to.return$Assignments, response$Assignments)

          # Add to running total
          runningtotal <- runningtotal + response$NumResults
          results.found <- response$NumResults

        }

        Assignments <- rbind(Assignments, to.return$Assignments)

      }
    }

    if (verbose) {
      message(runningtotal, " Assignments Retrieved")
    }
    return(Assignments)

  }
