#' Reshape roads dataframe into road.segments dataframe.
#'
#' For use in integrating pumps and cases into road network needed to compute walking neighbohoods.
#' @return An R dataframe.
#' @section Notes: This function documents the code that generates \code{\link[cholera]{road.segments}}.

roadSegments <- function() {
  dat <- cholera::roads[cholera::roads$street %in% cholera::border == FALSE, ]
  out <- lapply(unique(dat$street), function(i) {
   st <- dat[dat$street == i, ]
   names(st)[names(st) %in% c("x", "y")] <- c("x1", "y1")
   seg.end <- st[-1, c("x1", "y1")]
   names(seg.end) <- c("x2", "y2")
   st <- cbind(st[-nrow(st), c("street", "id", "name")],
               st[-nrow(st), c("x1", "y1")],
               seg.end)
   st$id <- paste0(st$street, "-", seq_len(nrow(st)))
   st
  })
  do.call(rbind, out)
}