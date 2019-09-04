#' Get HITs by Qualification
#'
#' Retrieve HITs according to the QualificationTypes that are required to
#' complete those HITs.
#'
#' A function to retrieve HITs that require the specified QualificationType.
#'
#' \code{gethitsbyqual()} and \code{ListHITsForQualificationType()} are aliases.
#'
#' @aliases GetHITsForQualificationType ListHITsForQualificationType gethitsbyqual
#' @param qual A character string containing a QualificationTypeId.
#' @param pagetoken An optional character string indicating which page of
#' search results to start at. Most users can ignore this.
#' @param results An optional character string indicating how many results to
#' fetch per page. Must be between 1 and 100. Most users can ignore this.
#' @param verbose Optionally print the results of the API request to the
#' standard output. Default is taken from \code{getOption('pyMTurkR.verbose',
#' TRUE)}.
#' @return A data frame containing the HITId and other requested
#' characteristics of the qualifying HITs.
#' @author Tyler Burleigh, Thomas J. Leeper
#' @references
#' \href{https://docs.aws.amazon.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_ListHITsForQualificationTypeOperation.html}{API Reference}
#' @keywords HITs Qualifications
#' @examples
#'
#' \dontrun{
#' GetHITsForQualificationType()
#' }
#'
#' @export GetHITsForQualificationType
#' @export ListHITsForQualificationType
#' @export gethitsbyqual

GetHITsForQualificationType <-
  ListHITsForQualificationType <-
  gethitsbyqual <-
  function (qual,
            results = as.integer(100),
            pagetoken = NULL,
            verbose = getOption('pyMTurkR.verbose', TRUE)) {

    GetClient() # Boto3 client

    batch <- function(pagetoken = NULL) {

      # Use page token if given
      if(!is.null(pagetoken)){
        response <- try(pyMTurkR$Client$list_hits_for_qualification_type(QualificationTypeId = qual,
                                                                NextToken = pagetoken,
                                                                MaxResults = as.integer(results)), silent = !verbose)
      } else {
        response <- try(pyMTurkR$Client$list_hits_for_qualification_type(QualificationTypeId = qual,
                                                                MaxResults = as.integer(results)), silent = !verbose)
      }

      # Validity check response
      if(class(response) == "try-error") {
        stop("Request failed")
      }

      if(length(response$HITs) > 0){
        response$QualificationRequirements <- ToDataFrameQualificationRequirements(response$HITs)
        response$HITs <- ToDataFrameHITs(response$HITs)
        return(response)
      } else {
        return(emptydf(nrow = 0, ncol = 6, c('HITId', 'QualificationTypeId',  'Comparator',
                                             'Value', 'RequiredToPreview', 'ActionsGuarded')))
      }
    }

    # Fetch first page
    response <- batch()
    results.found <- response$NumResults
    to.return <- response

    if (!is.null(response$NextToken) & results > results.found) { # continue to fetch pages

      # Starting with the next page, identified using NextToken
      pagetoken <- response$NextToken

      # Fetch while the number of results is equal to max results per page
      while (results.found == results) {

        # Fetch next batch
        response <- batch(pagetoken)

        # Add to HIT DF
        to.return$HITs <- rbind(to.return$HITs, response$HITs)

        to.return$QualificationRequirements <- rbind(to.return$QualificationRequirements,
                                                     response$QualificationRequirements)

        # Update results found
        if(!is.null(response)){
          results.found <- response$NumResults
        } else {
          results.found <- 0
        }

        # Update page token
        if(!is.null(response$NextToken)){
          pagetoken <- response$NextToken
        }
      }
    }

    if (verbose) {
      message(nrow(to.return$HITs), " HITs Retrieved")
    }
    return(to.return[c("HITs", "QualificationRequirements")])
  }

