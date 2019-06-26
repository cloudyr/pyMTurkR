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

GenerateQualificationRequirement <-
  function (quals) {

    quals.list <- list()

    for(i in 1:length(quals)){

      this.qual <- list()

      qual <- quals[[i]]
      qualid <- qual$QualificationTypeId
      comparator <- qual$Comparator
      if(exists('IntegerValues', where = qual)){
        integers <- list(qual$IntegerValues)
      } else if(exists('LocaleValues', where = qual)){
        locales <- qual$LocaleValues
        rm(integers)
      }
      if(exists('RequiredToPreview', where = qual))
        preview <- qual$RequiredToPreview
      if(exists('ActionsGuarded', where = qual))
        actions.guarded <- qual$ActionsGuarded

      if (!exists('qual')) {
        stop("No QualificationTypeId specified for item ", i, " in list")
      }
      if (!exists('comparator')) {
        stop("No Comparator specified for item ", i, " in list")
      }
      if (!exists('locales') & !exists('integers')) {
        stop("No IntegerValues / LocaleValues specified for item ", i, " in list")
      } else if (exists('locales') & exists('integers')) {
        stop("Error, IntegerValues and LocaleValues both specified for item ", i, " in list")
      }
      if (!exists('preview') & !exists('actions.guarded')){
        stop("No RequiredToPreview or ActionsGuarded specified for item ", i, " in list")
      } else if (exists('preview') & exists('actions.guarded')) {
        stop("Error, RequiredToPreview or ActionsGuarded both specified for item ", i, " in list")
      }

      # Check Comparator values
      if (qualid =="2ARFPLSP75KLA8M8DH1HTEQVJT3SY6") {
        message("A QualificationTypeId for a Sandbox Qualification has been used.")
      }
      if (comparator == "<") {
        comparator <- "LessThan"
      } else if(comparator == "<=") {
        comparator <- "LessThanOrEqualTo"
      } else if(comparator == ">") {
        comparator <- "GreaterThan"
      } else if(comparator == ">=") {
        comparator <- "GreaterThanOrEqualTo"
      } else if(comparator %in% c("=","==")) {
        comparator <- "EqualTo"
      } else if(comparator == "!=") {
        comparator <- "NotEqualTo"
      }
      if (!comparator %in% c("LessThan", "LessThanOrEqualTo",
                             "GreaterThan", "GreaterThanOrEqualTo", "EqualTo",
                             "NotEqualTo", "Exists", "DoesNotExist", "In", "NotIn")) {
        stop("Inappropriate comparator specified for QualificationRequirement")
      }
      if (qualid == "00000000000000000071" & !comparator %in% c("EqualTo", "NotEqualTo", "In", "NotIn")) {
        stop("Worker_Locale (00000000000000000071) Requirement can only be used with 'EqualTo', 'NotEqualTo', 'In', or 'NotIn' comparators")
      }
      # replace removed sandbox masters qualifications
      if (qualid %in% c("2F1KVCNHMVHV8E9PBUB2A4J79LU20F", "2TGBB6BFMFFOM08IBMAFGGESC1UWJX")) {
        warning("Categorization/Moderation Masters Qualifications have been removed.\nUsing generic Masters Qualification instead.")
        qualid <- "2ARFPLSP75KLA8M8DH1HTEQVJT3SY6"
      }
      # replace deprecated production masters qualifications
      if (qualid %in% c("2NDP2L92HECWY8NS8H3CK0CP5L9GHO", "21VZU98JHSTLZ5BPP4A9NOBJEK3DPG")) {
        warning("Categorization/Moderation Masters Qualifications have been removed.\nUsing generic Masters Qualification instead.")
        qualid <- "2F1QJWKUDD8XADTFD2Q0G6UTO95ALH"
      }
      if (qualid %in% c("2ARFPLSP75KLA8M8DH1HTEQVJT3SY6", "2F1QJWKUDD8XADTFD2Q0G6UTO95ALH") &&
          (!comparator %in% c("Exists","DoesNotExist"))) {
        stop("Masters qualifications can only accept 'Exists' comparator")
      }
      if (comparator %in% c("Exists","DoesNotExist") & ( exists('locales') | exists('integers') )) {
        if(exists('locales'))
          rm(locales)
        if(exists('integers'))
          rm(integers)
      }

      this.qual$QualificationTypeId <- qualid
      this.qual$Comparator <- comparator
      if(exists('preview'))
        this.qual$RequiredToPreview <- preview
      if(exists('actions.guarded'))
        this.qual$ActionsGuarded <- actions.guarded
      if(exists('integers'))
        this.qual$IntegerValues <- integers
      if(exists('locales'))
        this.qual$LocaleValues <- list(locales)

      quals.list[[length(quals.list) + 1]] <- this.qual

    }

    return.quals <- ""
    for(i in 1:length(quals.list)){
      return.quals <- paste0(return.quals, "reticulate::dict(", quals.list[i], ")")
      if(i < length(quals.list)) {
        return.quals <- paste0(return.quals, ", ")
      } else {
        return.quals <- paste0("reticulate::tuple(", return.quals, ")")
      }
    }

    # Hacky solution to integer type issue
    for(i in 1:length(quals)){
      if(exists('IntegerValues', where = quals[[i]])){
        # Add "L" suffix to number in string
        return.quals <- gsub(paste0("IntegerValues = list(", quals[[i]]$IntegerValues, ")"),
                             paste0("IntegerValues = list(", quals[[i]]$IntegerValues, "L)"),
                             return.quals, fixed = TRUE)

      }
    }

    return.quals

  }
