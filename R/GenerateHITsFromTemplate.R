#' Generate HITs from a Template
#'
#' Generate individual HIT .html files from a local .html HIT template file, in
#' the same fashion as the MTurk Requester User Interface (RUI).
#'
#' \code{GenerateHITsFromTemplate} generates individual HIT question content
#' from a HIT template (containing placeholders for input data of the form
#' \code{\${variablename}}). The tool provides functionality analogous to the
#' MTurk RUI HIT template and can be performed on .html files generated
#' therein. The HITs are returned as a list of character strings. If
#' \code{write.files = TRUE}, a side effect occurs in the form of one or more
#' .html files being written to the working directory, with filenames specified
#' by the \code{filenames} option or, if \code{filenames=NULL} of the form
#' \dQuote{NewHIT1.html}, \dQuote{NewHIT2.html}, etc.
#'
#' @param template A character string or filename for an .html HIT template
#' @param input A data.frame containing one row for each HIT to be created and
#' columns named identically to the placeholders in the HIT template file.
#' Operation will fail if variable names do not correspond.
#' @param filenames An optional list of filenames for the HITs to be created.
#' Must be equal to the number of rows in \code{input}.
#' @param write.files A logical specifying whether HIT .html files should be
#' created and stored in the working directory. Or, alternatively, whether HITs
#' should be returned as character vectors in a list.
#' @param \dots Additional arguments passed to \code{\link{CreateHIT}}.
#' @return A list containing a character string for each HIT generated from the
#' template.
#' @author Thomas J. Leeper
#' @seealso \code{\link{BulkCreateFromTemplate}}
#' @references
#' \href{http://docs.amazonwebservices.com/AWSMechTurk/latest/RequesterUI/CreatingaHITTemplate.html}{API Reference: Operation}
#'
#' \href{http://docs.amazonwebservices.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_ExternalQuestionArticle.html}{API Reference: ExternalQuestion Data Structure}
#' @keywords HITs
#' @examples
#'
#' \dontrun{
#' # create/edit template HTML file
#' # should have placeholders of the form `${varName}` for variable values
#' temp <- system.file("templates/htmlquestion2.xml", package = "pyMTurkR")
#' readLines(temp)
#'
#' # create/load data.frame of template variable values
#' a <- data.frame(hittitle = c("HIT title 1","HIT title 2","HIT title 3"),
#'                 hitvariable = c("HIT text 1","HIT text 2","HIT text 3"),
#'                 stringsAsFactors=FALSE)
#'
#' # create HITs from template and data.frame values
#' temps <- GenerateHITsFromTemplate(template = temp, input = a)
#'
#' # create HITs from template
#' hittype1 <- RegisterHITType(title = "2 Question Survey",
#'               description = "Complete a 2-question survey",
#'               reward = ".20",
#'               duration = seconds(hours=1),
#'               keywords = "survey, questionnaire, politics")
#' hits <- lapply(temps, function(x) {
#'     CreateHIT(hit.type = hittype1$HITTypeId,
#'               expiration = seconds(days = 1),
#'               assignments = 2,
#'               question = GenerateHTMLQuestion(x)$string)
#' })
#'
#' # cleanup
#' ExpireHIT(hit.type = hittype1$HITTypeId)
#' DisposeHIT(hit.type = hittype1$HITTypeId)
#' }
#'

GenerateHITsFromTemplate <-
function (template, input, filenames = NULL, write.files = FALSE) {
    if (!grepl("\\$\\{.+\\}", template)) {
        template <- readLines(template, warn = FALSE)
    }
    template <- paste0(template, collapse = "\n")
    HITs <- list()
    if (!is.null(filenames)) {
        if (!length(filenames) == dim(input)[1]) {
            stop("Number of inputs != length(filenames)")
        }
    }
    for (j in 1:nrow(input)) {
        newhit <- template
        for (i in 1:ncol(input)) {
            newhit <- gsub(paste0("\\$\\{",names(input)[i],"\\}"), input[j,i], newhit)
        }
        if (write.files == TRUE) {
            if (is.null(filenames)) {
                writeLines(newhit, paste("NewHIT", j, ".html", sep = ""))
            } else {
                writeLines(newhit, filenames[j])
            }
        }
        HITs[[j]] <- newhit
    }
    return(HITs)
}
