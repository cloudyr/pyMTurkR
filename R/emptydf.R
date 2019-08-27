#' Helper function that creates an empty data.frame
#'
#' @param nrow Number of rows
#' @param nrow Number of columns
#' @param nrow Number of names of the columns
#' @export
#'
emptydf <- function(nrow, ncol, names) {
    stats::setNames(data.frame(matrix(NA_character_, nrow = nrow, ncol = ncol),
                               stringsAsFactors = FALSE), names)
}
