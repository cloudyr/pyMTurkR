#' Helper function that creates an empty data.frame
#'
#' @param nrow Number of rows
#' @param ncol Number of columns
#' @param names Number of names of the columns
#' @return A data frame of NAs, with the given column names
#' @export
#'
emptydf <- function(nrow, ncol, names) {
    stats::setNames(data.frame(matrix(NA_character_, nrow = nrow, ncol = ncol),
                               stringsAsFactors = FALSE), names)
}
