#' Creates an MTurk Client using the AWS SDK for Python (Boto3)
#'
#' Create an API client. Only advanced users will likely need to use this
#' function. \code{CheckAWSKeys()} is a helper function that checks if your
#' AWS keys can be found.
#'
#' \code{StartClient()} is an alias
#'
#' @aliases GetClient StartClient
#' @param sandbox A logical indicating whether the client should be in the
#' sandbox environment or the live environment.
#' @param restart.client A boolean that specifies whether to force the creation of a new client.
#' @return No return value; Called to populate pyMTurkR$Client
#' @author Tyler Burleigh
#' @references
#' \href{https://aws.amazon.com/sdk-for-python/}{AWS SDK for Python (Boto3)}
#' \href{https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/mturk.html}{Boto3 Docs}
#'
#' @examples
#' \dontrun{
#' GetClient()
#' }
#' @export GetClient
#' @export StartClient

GetClient <-
StartClient <-
function(sandbox = getOption('pyMTurkR.sandbox', TRUE),
         restart.client = FALSE){

  helper_mturk_client <- function(sandbox, boto3){

    if(sandbox) endpoint_url <- 'https://mturk-requester-sandbox.us-east-1.amazonaws.com'
    else endpoint_url <- 'https://mturk-requester.us-east-1.amazonaws.com'

    # Check if AWS credentials can be found in an environment variable
    if(Sys.getenv("AWS_ACCESS_KEY_ID") != "" & Sys.getenv("AWS_SECRET_ACCESS_KEY") != ""){
      key <- Sys.getenv("AWS_ACCESS_KEY_ID")
      secret_key <- Sys.getenv("AWS_SECRET_ACCESS_KEY")
    } else {
      stop("ERROR: Missing AWS Access Key or Secret Access Key.")
    }

    # Start client
    client <- boto3$client('mturk', region_name='us-east-1',
                                    aws_access_key_id = key,
                                    aws_secret_access_key = secret_key,
                                    endpoint_url = endpoint_url)

    assign("Client", client, envir=pyMTurkR)

    # Test credentials with a simple API call
    helper_mturk_credentials_test()

  }

  helper_mturk_credentials_test <- function(){

    tryCatch({
      invisible(pyMTurkR$Client$get_account_balance()) # Test the credentials using a call to get_account_balance()
      invisible(pyMTurkR$Client)
    }, error = function(e) {
      message(paste(e, "    Check your AWS credentials."))
    })
  }

  if(!exists('pyMTurkR$Client') ||
     !class(pyMTurkR$Client)[[1]] == 'botocore.client.MTurk' ||
     restart.client){

    tryCatch({

      # Try loading boto3 module
      boto3 <- reticulate::import("boto3")

      tryCatch({ # Try starting client
        helper_mturk_client(sandbox, boto3) # If the module loaded, start the client
      }, error = function(e) {
        message(paste(e, "    Unable to authenticate with credentials."))
      })

    }, error = function(e) {
      message(paste(e, "    Unable to start boto3 client."))
    })
  }

}


#' Helper function to check AWS Keys
#'
#' Checks for the existence of environment variables AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY.
#'
#' @return A logical indicating whether AWS Keys were found as environment variables.
#' @export CheckAWSKeys
#'
CheckAWSKeys <- function(){
  if(Sys.getenv("AWS_ACCESS_KEY_ID") != "" & Sys.getenv("AWS_SECRET_ACCESS_KEY") != ""){
    return(TRUE)
  } else {
    return(FALSE)
  }
}

if(getRversion() >= "2.15.1") {
  utils::globalVariables(c("pyMTurkR"))
}
