#' Convert arbitrary times to seconds
#'
#' A convenience function to convert arbitrary numbers of days, hours, minutes,
#' and/or seconds into seconds.
#'
#' A convenience function to convert arbitrary numbers of days, hours, minutes,
#' and/or seconds into seconds. For example, to be used in setting a HIT
#' expiration time. MTurk only accepts times (e.g., for HIT expirations, or the
#' duration of assignments) in seconds. This function returns an integer value
#' equal to the number of seconds of the input, and can be used atomically
#' within other MTurkR calls (e.g., \code{\link{CreateHIT}}).
#'
#' @param days An optional number of days.
#' @param hours An optional number of hours.
#' @param minutes An optional number of minutes.
#' @param seconds An optional number of seconds.
#' @return An integer equal to the requested amount of time in seconds.
#' @author Thomas J. Leeper
#' @export


seconds <-
function (days = NULL, hours = NULL, minutes = NULL, seconds = NULL) {
    s1 <- if (!is.null(days)) as.numeric(days) * 24 * 60 * 60 else 0
    s2 <- if (!is.null(hours)) as.numeric(hours) * 60 * 60 else 0
    s3 <- if (!is.null(minutes)) as.numeric(minutes) * 60 else 0
    s4 <- if (!is.null(seconds)) as.numeric(seconds) else 0
    return(sum(c(s1, s2, s3, s4)))
}
