#' Parse MTurk XML to Data Frame
#' 
#' Parse MTurk XML Responses to R data.frames.
#' 
#' Mostly internal functions to convert XML-formatted MTurk responses into more
#' useful R data frames. These are mostly internal to the extent that most
#' users will never call them directly, but they may be useful if one needs to
#' examine information stored in the MTurkR log file, or if
#' \code{\link{request}} is used directly.
#' 
#' @aliases as.data.frame.MTurkResponse as.data.frame.AnswerKey
#' as.data.frame.Assignments as.data.frame.BonusPayments
#' as.data.frame.ExternalQuestion as.data.frame.HITs as.data.frame.HTMLQuestion
#' as.data.frame.QualificationRequests as.data.frame.QualificationRequirements
#' as.data.frame.Qualifications as.data.frame.QualificationTypes
#' as.data.frame.QuestionFormAnswers as.data.frame.QuestionForm
#' as.data.frame.ReviewResults as.data.frame.WorkerBlock
#' @param xml.parsed A full MTurk XML response parsed by the \code{xmlParse}.
#' @param xmlnodeset An XML nodeset.
#' @param return.assignment.xml A logical indicating whether workers' responses
#' to HIT questions should be returned.
#' @param return.hit.xml A logical indicating whether the HIT XML should be
#' returned. Default is \code{FALSE}.
#' @param return.qual.list A logical indicating whether the
#' QualificationRequirement list should be returned. Default is \code{TRUE}.
#' @param hit An optional parameter included for advanced users, to return only
#' one of the specified HITs.
#' @param hit.number An optional parameter included for advanced users, to
#' return only one of the specified HITs.
#' @param sandbox A logical indicating whether GetQualificationType, called
#' internally, should query the sandbox for user-defined QualificationTypes.
#' @return A data frame (or list of data frames, in some cases) containing the
#' request data.
#' @author Thomas J. Leeper
#' @references
#' \href{http://docs.amazonwebservices.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_DataStructuresArticle.htmlAPI
#' Reference: Data Structures}