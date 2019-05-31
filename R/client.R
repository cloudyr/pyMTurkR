#' Creates an MTurk Client using the AWS SDK for Python (Boto3)
#'
#' Approve assignments, by AssignmentId (as returned by
#' \code{\link{GetAssignment}} or by HITId or HITTypeId. Must specify
#' \code{assignments}.
#'
#' \code{StartClient()}, \code{Client() and \code{client()} are aliases for
#' \code{GetClient}.
#'
#' @aliases GetClient StartClient Client client
#' @param sandbox A logical indicating whether the client should be in the
#' sandbox environment or the live environment.
#' @param profile A character string that specifies the profile to use
#' from the .aws/credentials file.
#' @return An object with the classes \dQuote{botocore.client.MTurk},
#' \dQuote{botocore.client.BaseClient}, \dQuote{python.builtin.object}, that
#' is used as an MTurk client
#' @author Tyler Burleigh
#' @references
#' \href{https://aws.amazon.com/sdk-for-python/}{AWS SDK for Python (Boto3)}
#' \href{https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/mturk.html}{Boto3 Docs}
#'
#' @keywords client, start
#'
#' @examples
#' \dontrun{
#' GetClient()
#'
#' myclient <- GetClient()
#' myclient$get_account_balance()
#' }

GetClient <-
StartClient <-
Client <-
client <-
function(sandbox = TRUE, profile = 'default'){
  tryCatch({ # Try loading boto3 module
    boto3 <- reticulate::import("boto3")
    .helper_mturk_client(sandbox, profile, boto3) # If the module loaded, start the client
  }, error = function(e) {
    message(paste(e, "Did you install boto3 for this python environment? Run py_config() to see the python environment you're in."))
  })
}

.helper_mturk_client <- function(sandbox, profile, boto3){

  if(sandbox) endpoint_url = 'https://mturk-requester-sandbox.us-east-1.amazonaws.com'
  else endpoint_url = 'https://mturk-requester.us-east-1.amazonaws.com'

  # Check if AWS credentials exist for the profile
  if(length(aws.signature::read_credentials()[[profile]]$AWS_ACCESS_KEY_ID) == 0 |
     length(aws.signature::read_credentials()[[profile]]$AWS_SECRET_ACCESS_KEY) == 0)
        message("ERROR: Missing AWS Access Key or Secret Access Key.\n  Make sure AWS is configured correctly.")

  else { # If the credentials exist, load the client
    client <- boto3$client('mturk', region_name='us-east-1',
                                  aws_access_key_id = aws.signature::read_credentials()[[profile]]$AWS_ACCESS_KEY_ID,
                                  aws_secret_access_key = aws.signature::read_credentials()[[profile]]$AWS_SECRET_ACCESS_KEY,
                                  endpoint_url = endpoint_url)

    # Now test the credentials
    .helper_mturk_credentials_test(sandbox, client)
  }
}

.helper_mturk_credentials_test <- function(sandbox, client){
  if(sandbox) mode <- "\n[SANDBOX MODE]"
  else mode <- ""

  tryCatch({
    invisible(client$get_account_balance()) # Test the credentials using a call to get_account_balance()
    invisible(client)
  }, error = function(e) {
    message(paste(e, "Check your AWS credentials."))
  })
}
