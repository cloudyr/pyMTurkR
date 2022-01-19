#' Generate ExternalQuestion
#'
#' Generate an ExternalQuestion data structure for use in the \sQuote{Question}
#' parameter of the \code{\link{CreateHIT}} operation.
#'
#' An ExternalQuestion is a HIT stored anywhere other than the MTurk server
#' that is displayed to workers within an HTML iframe of the specified height.
#' The URL should point to a page --- likely an HTML form --- that can retrieve
#' several URL GET parameters for \dQuote{AssignmentId} and \dQuote{WorkerId},
#' which are attached by MTurk when opening the URL.
#'
#' Note: \code{url} must be HTTPS.
#'
#' @param url A character string containing the URL (served over HTTPS) of a
#' HIT file stored anywhere other than the MTurk server.
#' @param frame.height A character string containing the integer value (in
#' pixels) of the frame height for the ExternalQuestion iframe.
#' @return A list containing \code{xml.parsed}, an XML data structure,
#' \code{string}, xml formatted as a character string, and \code{url.encoded},
#' character string containing a URL query parameter-formatted HTMLQuestion
#' data structure for use in the \code{question} parameter of
#' \code{\link{CreateHIT}}.
#' @author Tyler Burleigh, Thomas J. Leeper
#' @seealso \code{\link{CreateHIT}}
#' @references
#' \href{https://docs.aws.amazon.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_ExternalQuestionArticle.html}{API Reference}
#' @keywords HITs
#' @examples
#'
#' \dontrun{
#' a <- GenerateExternalQuestion(url="http://www.example.com/", frame.height="400")
#'
#' hit1 <-
#' CreateHIT(title = "Survey",
#'           description = "5 question survey",
#'           reward = ".10",
#'           expiration = seconds(days = 4),
#'           duration = seconds(hours = 1),
#'           keywords = "survey, questionnaire",
#'           question = a$string)
#'
#' ExpireHIT(hit1$HITId)
#' DisposeHIT(hit1$HITId)
#' }
#'
#' @export

GenerateExternalQuestion <-
function (url, frame.height = 400) {
    external <- XML::newXMLNode("ExternalQuestion", namespaceDefinitions = "http://mechanicalturk.amazonaws.com/AWSMechanicalTurkDataSchemas/2006-07-14/ExternalQuestion.xsd")
    external.url <- XML::newXMLNode("ExternalURL", url, parent = external)
    external.frame <- XML::newXMLNode("FrameHeight", frame.height, parent = external)
    XML::addChildren(external, c(external.url, external.frame))
    string <- XML::toString.XMLNode(external)
    return(structure(list(xml.parsed = external,
                          string = string,
                          url.encoded = curl::curl_escape(string)),
                     class = 'ExternalQuestion'))
}
