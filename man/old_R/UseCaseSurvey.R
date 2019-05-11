#' Use Case: Surveys
#' 
#' This page describes how to use MTurkR to collect survey(-experimental) data
#' on Amazon Mechanical Turk.
#' 
#' MTurk is widely used as a platform for social research, due to its low
#' costs, ease of use, and quick access to participants. This use case tutorial
#' walks through how to create MTurk HITs using MTurkR. It also describes some
#' advanced features, such as managing panels of MTurk participants, and
#' randomizing content.
#' 
#' @aliases survey
#' @section Creating a survey HIT: Because a HIT is simply an HTML form, it is
#' possible to design an entire survey(-experimental) questionnaire directly in
#' MTurk. This could be done using an HTMLQuestion HIT. That would require,
#' however, an extensive knowledge of HTML, likely a fair amount of JavaScript
#' to display questions and validate worker responses, and a large amount of
#' CSS styling. An alternative approach is to use an off-site survey tool (such
#' as SurveyMonkey, Qualtrics, Google Spreadsheet Forms, etc.) to design a
#' questionnaire and then simply use a HIT to direct workers to that task.
#' There are two ways to do this in MTurkR. One is to create a \dQuote{link and
#' code} HIT that includes a link to an off-site tool and a text entry field
#' for a worker to enter a completion code. The other is to embed the
#' questionnaire directly as an ExternalQuestion HIT. The following two
#' sections describe these approaches.
#' 
#' \subsection{Link and code To use the link and code, the HIT must contain the
#' following:
#' 
#' \itemize{ \item A link to the off-site survey \item A text entry form field
#' into which the worker will enter a completion code \item Instructions to the
#' worker about how to complete the HIT \item Optionally, JavaScript to
#' dynamically display the link and/or entry field }
#' 
#' MTurkR includes an XML file that could be used to create an HTMLQuestion
#' \dQuote{link and code} HIT. You can find it in
#' \code{system.file("templates/htmlquestion1.xml", package = "MTurkR")}. A
#' more robust example of an HTMLQuestion showing a survey link that is
#' dynamically displayed once the HIT is accepted is included as
#' \code{system.file("templates/surveylink.xml", package = "MTurkR")}. You can
#' also create a HIT of this kind on the MTurk requester user interface (RUI)
#' website.
#' 
#' } \subsection{ExternalQuestion The link and code method is easier to setup,
#' but invites problems with workers entering fake codes, workers completing
#' the survey but not entering the code (and thus not getting paid), and other
#' human error possibilities. By contrast, the ExternalQuestion method provides
#' a seamless link between the MTurk interface and an off-site tool. Instead of
#' showing the worker an HTML page with a link, configuring an ExternalQuestion
#' actually shows the worker the survey directly inside an iframe in the MTurk
#' worker interface. This eliminates the need for the requester to create codes
#' and for workers to copy them.
#' 
#' The trade-off is that this method requires a somewhat sophisticated survey
#' tool (e.g., Qualtrics) that can handle redirecting the worker back to the
#' ExternalQuestion submit URL for their assignment. The submit URL has to take
#' the form of:
#' \samp{https://www.mturk.com/mturk/externalSubmit?assignmentId=workerspecificassignmentid&foo=bar}.
#' The \samp{foo=bar} part is required by MTurk (it requires the assignmentId
#' and at least one other field). Note: The previous link is for the live
#' server. For testing in the requester sandbox, the base URL is:
#' \samp{https://workersandbox.mturk.com/mturk/externalSubmit}.
#' 
#' Creating the HIT itself is quite simple. It simply requires registering a
#' HITType, building the ExternalQuestion structure (in which you can specify
#' the height of the iframe in pixels), and using it in
#' \code{\link{CreateHIT}}:
#' 
#' \verb{ newhittype <- RegisterHITType(title = "10 Question Survey",
#' description = "Complete a 10-question survey about news coverage and your
#' opinions", reward = ".20", duration = seconds(hours=1), keywords = "survey,
#' questionnaire, politics") eq <-
#' GenerateExternalQuestion(url="https://www.example.com/myhit.html",frame.height="400")
#' CreateHIT(hit.type = newhittype$HITTypeId, question = eq$string, expiration
#' = seconds(1), assignments = 1) }
#' 
#' To make this work with a Qualtrics survey URL, do the following:
#' 
#' \enumerate{ \item Create the Qualtrics survey \item Setup the Qualtrics
#' survey to extract embedded URL parameters (see
#' \href{http://qualtrics.com/university/researchsuite/advanced-building/survey-flow/embedded-data/documentation}),
#' which MTurk will attach to the Qualtrics survey link. You need to extract
#' the \samp{assignmentId} field. It is also helpful to extract the
#' \samp{workerId} field to embed it in the survey dataset as a unique
#' identifier for each respondent.  \item Setup the Qualtrics survey to
#' redirect (at completion) to the ExternalQuestion submit URL, using the
#' \samp{assignmentId} (the embedded data field) and at least one other survey
#' field. See
#' \href{http://qualtrics.com/university/researchsuite/basic-building/basic-survey-options/survey-termination/Qualtrics
#' documentation} for details. For the live server, this URL should look like:
#' \samp{https://www.mturk.com/mturk/externalSubmit?assignmentId=${e://Field/assignmentId}&foo=bar}
#' and for the sandbox it should look like:
#' \samp{https://workersandbox.mturk.com/mturk/externalSubmit?assignmentId=${e://Field/assignmentId}&foo=bar}.
#' \item Create an ExternalQuestion HIT via MTurkR using the survey link from
#' Qualtrics, as in the example above. }
#' 
#' }
#' @seealso For guidance on some of the functions used in this tutorial, see:
#' \itemize{ \item \code{\link{CreateHIT}} \item \code{\link{GetAssignments}}
#' \item \code{\link{ContactWorkers}} \item \code{\link{GrantBonus}} \item
#' \code{\link{CreateQualificationType}} }
#' 
#' For some other tutorials on how to use MTurkR for specific use cases, see
#' the following: \itemize{ %\item \link{survey}, for collecting
#' survey(-experimental) data \item \link{categorization}, for doing
#' large-scale categorization (e.g., photo moderation or developing a training
#' set) \item \link{sentiment}, for doing sentiment coding \item
#' \link{webscraping}, for manual scraping of web data }
#' @keywords Use Cases