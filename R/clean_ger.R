

#' Convert messy german characters to readable output
#'
#'
#' @rdname clean_ger
#' @references
#' Convert messy german characters to readable output
#'


#' @export
#' @rdname clean_ger
clean_ger <- function (x) {
  x = gsub("â€“", "–", x)
  x = gsub("Ãœ", "Ü", x)
  x = gsub("Ã¤", "ä", x)
  x = gsub("Â»", "»", x)
  x = gsub("Ã¼", "ü", x)
  x = gsub("â€˜", "‘", x)
  x = gsub("Ã¶", "ö", x)
  x = gsub("âˆ’", "?", x)
  x
}
