#' Use Case: Categorization
#' 
#' This page describes how to use MTurkR to collect categorization data
#' 
#' This page describes how to use MTurkR to collect categorization data
#' (perhaps for photo moderation or developing a training set) on Amazon
#' Mechanical Turk. The workflow here is very similar to that for sentiment
#' analysis (see \link{sentiment}).
#' 
#' The basic workflow for categorization is as follows: \enumerate{ \item
#' Develop an HTML form template to display and record data \item Optionally,
#' develop a Qualification Test to select high-quality workers \item Create a
#' HITType (a display group) to organize the HITs you will produce \item Create
#' the HITs from the template and an input data.frame \item Monitor and
#' retrieve results }
#' 
#' @aliases categorization
#' @section Creating a Categorization Template: MTurkR comes pre-installed with
#' a HTMLQuestion HIT template showing the basic form of a categorization
#' project (see \code{system.file("templates/categorization1.xml", package =
#' "MTurkR")}. This template simply displays an image from a specified URL and
#' asks workers to categorize the image as one of five things (person, animal,
#' fruit, vegetable, or something else). Because an HTMLQuestion HIT is just an
#' HTML document containing a form, we have one \samp{<input>} field for each
#' possible category with the name \samp{QuestionId1} which is the data field
#' we are interested in analyzing when we retrieve the results.
#' 
#' For your own project, you may want to add additional elements such as
#' instructions to workers about how to perform the task, additional response
#' options, or perhaps multiple dimensions on which to categorize (resolution,
#' clarity, etc.). The key thing to remember is that the template must contain
#' a template field which is what will be replaced by
#' \code{\link{BulkCreateFromTemplate}} when you create the HITs. Note in the
#' example template that the field is actually used in three places: (1) as the
#' \samp{src} of the HTML image field, (2) as the alt display text (in case the
#' image doesn't load correctly), and (3) in a hidden form field. The last of
#' these ensures that we are able to quickly and easily map the particular
#' images into the categorization results returned by MTurk. If we don't do
#' this, we will need to \code{\link[base]{merge}} the results data with
#' information about what image was displayed to each worker (because of an
#' unfortunate feature of the MTurk API), so this saves us time later on.
#' @author Thomas J. Leeper
#' @seealso For guidance on some of the functions used in this tutorial, see:
#' \itemize{ \item \code{\link{CreateQualificationType}} \item
#' \code{\link{GenerateQualificationRequirement}} \item
#' \code{\link{RegisterHITType}} \item \code{\link{BulkCreate}} \item
#' \code{\link{HITStatus}} \item \code{\link{GetAssignments}} }
#' 
#' For some other tutorials on how to use MTurkR for specific use cases, see
#' the following: \itemize{ \item \link{survey}, for collecting
#' survey(-experimental) data %\item \link{categorization}, for doing
#' large-scale categorization (e.g., photo moderation or developing a training
#' set) \item \link{sentiment}, for doing sentiment coding \item
#' \link{webscraping}, for manual scraping of web data }
#' @keywords Use Cases