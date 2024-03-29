% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/CreateHIT.R
\name{CreateHIT}
\alias{CreateHIT}
\alias{createhit}
\alias{create}
\alias{CreateHITWithHITType}
\alias{createhitwithhittype}
\title{Create HIT}
\usage{
CreateHIT(
  hit.type = NULL,
  question = NULL,
  expiration,
  assignments = NULL,
  assignment.review.policy = NULL,
  hit.review.policy = NULL,
  annotation = NULL,
  unique.request.token = NULL,
  title = NULL,
  description = NULL,
  reward = NULL,
  duration = NULL,
  keywords = NULL,
  auto.approval.delay = NULL,
  qual.req = NULL,
  hitlayoutid = NULL,
  hitlayoutparameters = NULL,
  verbose = getOption("pyMTurkR.verbose", TRUE)
)
}
\arguments{
\item{hit.type}{An optional character string specifying the HITTypeId that
this HIT should be generated from. If used, the HIT will inherit title,
description, keywords, reward, and other properties of the HIT.}

\item{question}{A mandatory (unless layoutid is specified) character string
containing a QuestionForm, HTMLQuestion, or ExternalQuestion data structure.
In lieu of a question parameter, a \code{hitlayoutid} and, optionally,
\code{hitlayoutparameters} can be specified.}

\item{expiration}{The time (in seconds) that the HIT should be available to
workers. Must be between 30 and 31536000 seconds.}

\item{assignments}{A character string specifying the number of assignments}

\item{assignment.review.policy}{An optional character string containing an
Assignment-level ReviewPolicy data structure as returned by \code{\link{GenerateAssignmentReviewPolicy}}.}

\item{hit.review.policy}{An optional character string containing a HIT-level
ReviewPolicy data structure as returned by \code{\link{GenerateHITReviewPolicy}}.}

\item{annotation}{An optional character string annotating the HIT. This is
not visible to workers, but can be used as a label by which to identify the
HIT from the API.}

\item{unique.request.token}{An optional character string, included only for
advanced users. It can be used to prevent creating a duplicate HIT. A HIT
will not be creatd if a HIT was previously granted (within a short time
window) using the same \code{unique.request.token}.}

\item{title}{A character string containing the title for the HITType. All
HITs of this HITType will be visibly grouped to workers according to this
title. Maximum of 128 characters.}

\item{description}{A character string containing a description of the
HITType. This is visible to workers. Maximum of 2000 characters.}

\item{reward}{A character string containing the per-assignment reward
amount, in U.S. Dollars (e.g., \dQuote{0.15}).}

\item{duration}{A character string containing the amount of time workers
have to complete an assignment for HITs of this HITType, in seconds (for
example, as returned by \code{\link{seconds}}). Minimum of 30 seconds and
maximum of 365 days.}

\item{keywords}{An optional character string containing a comma-separated
set of keywords by which workers can search for HITs of this HITType.
Maximum of 1000 characters.}

\item{auto.approval.delay}{An optional character string specifying the
amount of time, in seconds (for example, as returned by
\code{\link{seconds}}), before a submitted assignment is automatically
granted. Maximum of 30 days.}

\item{qual.req}{An optional list containing one or more
QualificationRequirements, for example as returned by
\code{\link{GenerateQualificationRequirement}}.}

\item{hitlayoutid}{An optional character string including a HITLayoutId
retrieved from a HIT \dQuote{project} template generated in the Requester
User Interface at \samp{https://requester.mturk.com/create/projects}. If the
HIT template includes variable placeholders, must also specify
\code{hitlayoutparameters}.}

\item{hitlayoutparameters}{Required if using a hitlayoutid with placeholder values.
This must be a list of lists containing Name and String values.}

\item{verbose}{Optionally print the results of the API request to the
standard output. Default is taken from \code{getOption('pyMTurkR.verbose',
TRUE)}.}
}
\value{
A data frame containing the HITId and other details of the newly
created HIT.
}
\description{
Create a single HIT. This is the most important function in the package. It
creates a HIT based upon the specified parameters: (1) characteristics
inherited from a HITType or specification of those parameters and (2) some
kind of Question data structure.
}
\details{
This function creates a new HIT and makes it available to workers.
Characteristics of the HIT can either be specified by including a valid
HITTypeId for \dQuote{hit.type} or creating a new HITType by atomically
specifying the characteristics of a new HITType.

When creating a HIT, some kind of Question data structure must be specified.
Either, a QuestionForm, HTMLQuestion, or ExternalQuestion data structure can
be specified for the \code{question} parameter or, if a HIT template created
in the Requester User Interface (RUI) is being used, the appropriate
\code{hitlayoutid} can be specified. If the HIT template contains variable
placeholders, then the \code{hitlayoutparameters} should also be specified.

When creating a ExternalQuestion HITs, the
\code{\link{GenerateHITsFromTemplate}} function can emulate the HIT template
functionality by converting a template .html file into a set of individual
HIT .html files (that would also have to be uploaded to a web server) and
executing \code{CreateHIT} for each of these external files with an
appropriate ExternalQuestion data structure specified for the
\code{question} parameter.

Note that HIT and Assignment Review Policies are not currently supported.

\code{createhit()}, \code{create()}, \code{CreateHITWithHITType()},
and \code{createhitwithhittype()} are aliases.
}
\examples{

\dontrun{

CreateHIT(title = "Survey",
         description = "5 question survey",
         reward = "0.10",
         assignments = 1,
         expiration = seconds(days = 4),
         duration = seconds(hours = 1),
         keywords = "survey, questionnaire",
         question = GenerateExternalQuestion("https://www.example.com/","400"))
}

}
\references{
\href{https://docs.aws.amazon.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_CreateHITOperation.html}{API Reference}
}
\author{
Tyler Burleigh, Thomas J. Leeper
}
\keyword{HITs}
