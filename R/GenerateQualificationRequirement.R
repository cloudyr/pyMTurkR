#' Generate QualificationRequirement
#'
#' Generate a QualificationRequirement data structure for use with
#' \code{\link{CreateHIT}} or \code{\link{RegisterHITType}}.
#'
#' A convenience function to translate the details of a
#' QualificationRequirement into the necessary structure for use in the
#' \code{qual.req} parameter of \code{\link{CreateHIT}} or
#' \code{\link{RegisterHITType}}. The function accepts a list of lists of
#' Qualification parameters.
#'
#' @param quals A list of lists of Qualification parameters. Each list contains:
#' QualificationTypeId (string, REQUIRED), Comparator (string, REQUIRED),
#' LocaleValues (vector of integers), LocaleValues (list containing Country
#' = string, and optionally Subdivision = string), RequiredToPreview (logical),
#' ActionsGuarded (string). See example below.
#'
#' @return Returns a special reticulated 'tuple' object
#' @author Tyler Burleigh, Thomas J. Leeper
#' @seealso \code{\link{CreateHIT}}
#'
#' \code{\link{RegisterHITType}}
#' @references
#' \href{https://docs.aws.amazon.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_QualificationRequirementDataStructureArticle.html}{API Reference}
#' @keywords Qualifications
#' @examples
#'
#' \dontrun{
#' quals.list <- list(
#'     list(QualificationTypeId = "2F1KVCNHMVHV8E9PBUB2A4J79LU20F",
#'          Comparator = "Exists",
#'          IntegerValues = 1,
#'          RequiredToPreview = TRUE
#'     ),
#'     list(QualificationTypeId = "00000000000000000071",
#'          Comparator = "EqualTo",
#'          LocaleValues = list(Country = "US"),
#'          RequiredToPreview = TRUE
#'     )
#' )
#' GenerateQualificationRequirement(quals.list) -> qual.req
#' }
#'
#'
#' @export

GenerateQualificationRequirement <-
  function (quals) {

    quals.list <- list()

    for(i in 1:length(quals)){

      this.qual <- list()
      qual <- quals[[i]]

      if (!exists('qual')) {
        stop("No QualificationTypeId specified for item ", i, " in list")
      }
      if (!exists('Comparator', where = qual)) {
        stop("No Comparator specified for item ", i, " in list")
      }
      if (!exists('LocaleValues', where = qual) & !exists('IntegerValues', where = qual)) {
        stop("No IntegerValues / LocaleValues specified for item ", i, " in list")
      } else if (exists('LocaleValues', where = qual) & exists('IntegerValues', where = qual)) {
        stop("Error, IntegerValues and LocaleValues both specified for item ", i, " in list")
      }
      if (!exists('RequiredToPreview', where = qual) & !exists('ActionsGuarded', where = qual)){
        stop("No RequiredToPreview or ActionsGuarded specified for item ", i, " in list")
      } else if (exists('RequiredToPreview', where = qual) & exists('ActionsGuarded', where = qual)) {
        stop("Error, RequiredToPreview or ActionsGuarded both specified for item ", i, " in list")
      }

      # Check Comparator values
      if (qual$QualificationTypeId =="2ARFPLSP75KLA8M8DH1HTEQVJT3SY6") {
        message("A QualificationTypeId for a Sandbox Qualification has been used.")
      }
      if (qual$Comparator == "<") {
        qual$Comparator <- "LessThan"
      } else if(qual$Comparator == "<=") {
        qual$Comparator <- "LessThanOrEqualTo"
      } else if(qual$Comparator == ">") {
        qual$Comparator <- "GreaterThan"
      } else if(qual$Comparator == ">=") {
        qual$Comparator <- "GreaterThanOrEqualTo"
      } else if(qual$Comparator %in% c("=","==")) {
        qual$Comparator <- "EqualTo"
      } else if(qual$Comparator == "!=") {
        qual$Comparator <- "NotEqualTo"
      }
      if (!qual$Comparator %in% c("LessThan", "LessThanOrEqualTo",
                             "GreaterThan", "GreaterThanOrEqualTo", "EqualTo",
                             "NotEqualTo", "Exists", "DoesNotExist", "In", "NotIn")) {
        stop("Inappropriate comparator specified for QualificationRequirement")
      }
      if (qual$QualificationTypeId == "00000000000000000071" & !qual$Comparator %in% c("EqualTo", "NotEqualTo", "In", "NotIn")) {
        stop("Worker_Locale (00000000000000000071) Requirement can only be used with 'EqualTo', 'NotEqualTo', 'In', or 'NotIn' comparators")
      }
      # replace removed sandbox masters qualifications
      if (qual$QualificationTypeId %in% c("2F1KVCNHMVHV8E9PBUB2A4J79LU20F", "2TGBB6BFMFFOM08IBMAFGGESC1UWJX")) {
        warning("Categorization/Moderation Masters Qualifications have been removed.\nUsing generic Masters Qualification instead.")
        qual$QualificationTypeId <- "2ARFPLSP75KLA8M8DH1HTEQVJT3SY6"
      }
      # replace deprecated production masters qualifications
      if (qual$QualificationTypeId %in% c("2NDP2L92HECWY8NS8H3CK0CP5L9GHO", "21VZU98JHSTLZ5BPP4A9NOBJEK3DPG")) {
        warning("Categorization/Moderation Masters Qualifications have been removed.\nUsing generic Masters Qualification instead.")
        qual$QualificationTypeId <- "2F1QJWKUDD8XADTFD2Q0G6UTO95ALH"
      }
      if (qual$QualificationTypeId %in% c("2ARFPLSP75KLA8M8DH1HTEQVJT3SY6", "2F1QJWKUDD8XADTFD2Q0G6UTO95ALH") &&
          !qual$Comparator %in% c("Exists","DoesNotExist")) {
        stop("Masters qualifications can only accept 'Exists' comparator")
      }
      if (qual$Comparator %in% c("Exists","DoesNotExist") & (exists('LocaleValues', where = qual) | exists('IntegerValues', where = qual)) ) {
        if(exists('LocaleValues', where = qual))
          qual$LocaleValues <- NULL
        if(exists('IntegerValues', where = qual))
          qual$IntegerValues <- NULL
      }

      this.qual$QualificationTypeId <- qual$QualificationTypeId
      this.qual$Comparator <- qual$Comparator
      if(exists('RequiredToPreview', where = qual))
        this.qual$RequiredToPreview <- qual$RequiredToPreview
      if(exists('actions.guarded', where = qual))
        this.qual$ActionsGuarded <- qual$ActionsGuarded
      if(exists('IntegerValues', where = qual))
        this.qual$IntegerValues <- list(as.integer(qual$IntegerValues))
      if(exists('LocaleValues', where = qual))
        this.qual$LocaleValues <- list(qual$LocaleValues)

      quals.list <- c(quals.list, reticulate::dict(this.qual))

    }

    quals.list

  }
