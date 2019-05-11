#' Use Case: Scraping
#' 
#' Use MTurkR to manually scrape web pages or documents
#' 
#' This page describes how to use MTurkR to scrape human-readable data from the
#' web or other sources using Amazon Mechanical Turk. While webscraping
#' packages (such as XML, xml2, rvest, RSelenium) make it easy to retrieve
#' structured web data and OCR technologies make it possible to extract text
#' from PDFs and images, there are some cases in which data is stored in forms
#' that are primarily human-readable rather than machine-readable. This
#' particularly the case when information is textual but unstructured such as
#' information stored in ad-hoc formats across different web pages (e.g.,
#' contact information for businesses) or in formats that are difficult or
#' annoying to automatically scrape (e.g., PDF). This tutorial describes how to
#' use MTurkR to gather data from these kinds of sources.
#' 
#' @aliases webscraping
#' @section Designing a HIT: The first step for a scraping project is to
#' identify sources of information and decide what data you need to extract
#' from those sources. Given the potentially massive variation in specific use
#' cases, this tutorial will not address any particular solution in-depth. Once
#' you have identified what information you would like to extract from the
#' documents, you have to create a form representation in which the MTurk
#' workers will submit information for a given document. This can be a
#' QuestionForm (see \code{\link{CreateHIT}}), which is a proprietary markup,
#' or more easily just an HTML form (see \code{\link{GenerateHTMLQuestion}}).
#' An example of QuestionForm markup is given in
#' \code{system.file("templates/tictactoe.xml", package = "MTurkR")} and an
#' example of an HTMLQuestion markup is given in
#' \code{system.file("templates/htmlquestion3.xml", package = "MTurkR")}.
#' Either is perfectly acceptable. For those with HTML experience, HTMLQuestion
#' is the easier approach; for those interested in making a very simple HIT and
#' who have no previous HTML experience, QuestionForm may be easier to work
#' with.
#' 
#' When designing the HIT, it should either contain a template placeholder (see
#' an example in \code{system.file("templates/htmlquestion2.xml", package =
#' "MTurkR")}) or you should create a separate HIT source file for every
#' document or webpage that you wanted to scrape. Using a template is simple
#' if, for example, you want to scrape information from a list of websites
#' because you can create a basic template and then use
#' \code{\link{BulkCreateFromTemplate}} to add the website URL (and perhaps
#' other details) to the HIT. If you are scraping a smaller number of documents
#' that are quite irregular in format, it may be easier to manually create each
#' HIT, save it as an .html file, and then create using either
#' \code{\link{BulkCreate}} (if you store the .html files locally) or
#' \code{\link{BulkCreateFromURLs}} if you upload those files to a remote
#' server (e.g., Amazon S3).
#' 
#' The remainder of this tutorial will assume you have created the files
#' manually and either wish to create HITs from the local files or from
#' publicly accessible URLs for the server to which those HIT files have been
#' uploaded. If neither of these cases applies (e.g., you want to use a HIT
#' template), consider reading the \dQuote{Use Case: Categorization} tutorial
#' (see \code{categorization}).
#' @author Thomas J. Leeper
#' @seealso For guidance on some of the functions used in this tutorial, see:
#' \itemize{ \item \code{\link{BulkCreate}} \item \code{\link{HITStatus}} \item
#' \code{\link{GetAssignments}} }
#' 
#' For some other tutorials on how to use MTurkR for specific use cases, see
#' the following: \itemize{ \item \link{survey}, for collecting
#' survey(-experimental) data \item \link{categorization}, for doing
#' large-scale categorization (e.g., photo moderation or developing a training
#' set) \item \link{sentiment}, for doing sentiment coding %\item
#' \link{webscraping}, for manual scraping of web data }
#' @keywords Use Cases