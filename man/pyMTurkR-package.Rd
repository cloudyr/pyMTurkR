\name{pyMTurkR-package}
\alias{pyMTurkR-package}
\alias{pyMTurkR}
\docType{package}
\title{R Client for the MTurk Requester API}
\description{

This package provides access to the Amazon Mechanical Turk (MTurk) Requester API. The package provides users of the MTurk Requester User Interface with access to a variety of functions currently unavailable to them (the creation and maintenance of worker Qualifications, email notifications to workers through \code{\link{ContactWorker}}, automated reviewing of assignments using Review Policies, and streamlined bonus payments through \code{\link{GrantBonus}}). It also provides users with all functions available in the RUI directly in R as well as a large number of other functions, and a simple, interactive command-line tool for performing many operations.

Most users will find themselves using three principal functions: \code{\link{CreateHIT}}, \code{\link{GetAssignments}}, and \code{\link{ApproveAssignments}}, to create one or more HITs on the MTurk server, to retrieve completed assignments, and to approve assignments (and thus pay workers), respectively. As task complexity increases, additional functions are provided to handle worker qualifications, bonuses, emails to workers, automated review policies, bulk creation of HITs, and so forth.

Critically important, nothing in pyMTurkR will work during a given session without either first setting AWS credentials. The easiest way to do this is to specify \samp{AWS_ACCESS_KEY_ID} and \samp{AWS_SECRET_ACCESS_KEY} environment variables using \code{Sys.setenv()} or by placing these values in an .Renviron file. Credentials can also be specified in an AWS CLI credentials file \href{https://boto3.amazonaws.com/v1/documentation/api/latest/guide/quickstart.html#configuration}{as described here}.

This package is a reboot of the MTurkR package after the MTurk API was updated in June 2019 and rendered it obsolete. This package uses reticulate to wrap boto3, the AWS SDK for Python, and access the MTurk API functions.

}
\author{
Tyler Burleigh

Maintainer: Tyler Burleigh <tylerburleigh@gmail.com>
}
\references{
\href{https://www.mturk.com/}{Amazon Mechanical Turk}

\href{https://docs.aws.amazon.com/mturk/}{Amazon Mechanical Turk API Documentation}
}
\keyword{ package }
\seealso{

To get started using pyMTurkR, see the documentation for \code{\link{CreateHIT}} (for creating single tasks). For some tutorials on how to use MTurkR for specific use cases, see the following:

}
%\examples{}
