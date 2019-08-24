emptydf <- function(nrow, ncol, names) {
    stats::setNames(data.frame(matrix(NA_character_, nrow = nrow, ncol = ncol),
                               stringsAsFactors = FALSE), names)
}
