#' Get Qualifications
#'
#' Get all Qualifications of a particular QualificationType assigned to
#' Workers.
#'
#' A function to retrieve Qualifications granted for the specified
#' QualificationType. To retrieve a specific Qualification score (e.g., for one
#' worker), use \code{\link{GetQualificationScore}}.
#'
#' A practical use for this is with automatically granted QualificationTypes.
#' After workers request and receive an automatically granted Qualification
#' that is tied to one or more HITs, \code{GetQualifications} can be used to
#' retrieve the WorkerIds for workers that are actively working on those HITs
#' (even before they have submitted an assignment).
#'
#' \code{getquals()} and \code{ListWorkersWithQualificationType()} are aliases.
#'
#' @aliases GetQualifications ListWorkersWithQualificationType getquals
#' @param qual A character string containing a QualificationTypeId for a custom
#' (i.e., not built-in) QualificationType.
#' @param status An optional character string specifying whether only
#' \dQuote{Granted} or \dQuote{Revoked} Qualifications should be returned.
#' @param pagetoken An optional character string indicating which page of
#' search results to start at. Most users can ignore this.
#' @param results An optional character string indicating how many results to
#' fetch per page. Must be between 1 and 100. Most users can ignore this.
#' @param verbose Optionally print the results of the API request to the
#' standard output. Default is taken from \code{getOption('pyMTurkR.verbose',
#' TRUE)}.
#' @return A data frame containing the QualificationTypeId, WorkerId, and
#' Qualification scores of workers assigned the Qualification.
#' @author Tyler Burleigh, Thomas J. Leeper
#' @seealso \code{\link{GetQualificationScore}}
#'
#' \code{\link{UpdateQualificationScore}}
#' @references
#' \href{https://docs.aws.amazon.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_ListWorkersWithQualificationTypeOperation.html}{API Reference}
#' @keywords Qualifications
#' @examples
#'
#' \dontrun{
#' qual1 <- AssignQualification(workers = "A1RO9UJNWXMU65",
#'                     name = "Worked for me before",
#'                     description = "This qualification is for people who have worked for me before",
#'                     status = "Active",
#'                     keywords = "Worked for me before")
#'
#' GetQualifications(qual1$QualificationTypeId)
#' RevokeQualification(qual1$QualificationTypeId, qual1$WorkerId)
#' GetQualifications(qual1$QualificationTypeId, status="Revoked")
#'
#' DisposeQualificationType(qual1$QualificationTypeId)
#' }
#'
#' @export GetQualifications
#' @export ListWorkersWithQualificationType
#' @export getquals

GetQualifications <-
  ListWorkersWithQualificationType <-
  getquals <-
  function (qual, status = NULL,
            results = as.integer(100), pagetoken = NULL,
            verbose = getOption('pyMTurkR.verbose', TRUE)) {

    GetClient() # Boto3 client

    batch <- function(pagetoken = NULL) {

      # List to store arguments
      args <- list(QualificationTypeId = qual,
                   MaxResults = as.integer(results))

      # Set the function to use later (this one has a hit type)
      fun <- .pyMTurkRClient$list_workers_with_qualification_type

      if(!is.null(pagetoken)){
        args <- c(args, NextToken = pagetoken)
      }
      if(!is.null(status)){
        args <- c(args, Status = status)
      }

      # Execute the API call
      response <- try(
        do.call('fun', args), silent = !verbose
      )

      # Validity check response
      if(class(response) == "try-error") {
        stop("Request failed")
      }

      response$Qualifications <- ToDataFrameQualifications(response$Qualifications)
      return(response)
    }


    # Fetch first page
    response <- batch()
    results.found <- response$NumResults
    to.return <- response

    # Keep a running total of all HITs returned
    runningtotal <- response$NumResults

    if (!is.null(response$NextToken)) { # continue to fetch pages

      # Starting with the next page, identified using NextToken
      pagetoken <- response$NextToken

      # Fetch while the number of results is equal to max results per page
      while (results.found == results) {

        # Fetch next batch
        response <- batch(pagetoken)

        # Add to HIT DF
        to.return$Qualifications <- rbind(to.return$Qualifications, response$Qualifications)

        results.found <- response$NumResults

        # Update page token
        if(!is.null(response$NextToken)){
          pagetoken <- response$NextToken
        }
      }
    }

    if (verbose) {
      message(nrow(to.return$Qualifications), " Qualifications Retrieved")
    }
    return(to.return$Qualifications)

  }
