#' Create a set of colors for pump neighborhoods.
#'
#' Uses RColorBrewer::brewer.pal().
#' @param vestry Logical. TRUE uses the 14 pumps in the Vestry Report. FALSE uses the original 13.
#' @return A character vector of colors.
#' @export

snowColors <- function(vestry = FALSE) {
  colors.pair <- RColorBrewer::brewer.pal(10, "Paired")
  colors.dark <- RColorBrewer::brewer.pal(8, "Dark2")
  if (vestry) {
    out <- c("dodgerblue", "gray", colors.dark[1:4], colors.pair[2],
      colors.dark[5:8], "red", colors.pair[1], "darkorange")
    names(out) <- paste0("p", 1:14)
  } else {
    out <- c("dodgerblue", "gray", colors.dark[1:4], colors.pair[2],
      colors.dark[5:8], "red", colors.pair[1])
    names(out) <- paste0("p", 1:13)
  }
  out
}
