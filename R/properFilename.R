

#' Creates proper filenames in eyp style
#'
#'
#' @rdname properFilename
#' @references
#'

# assembles a ey-p style filename
#' @export
#' @rdname properFilename
properFilename <- function(name = "test", project="51103", path="", kuerzel="JSA", fileType = "xlsx") {
  date = format(Sys.Date(),"%y%m%d")
  paste(paste(project, date, kuerzel, sep="-"), " ", name, ".", fileType, sep="")
}

# cleans out umlaute
clean_umlaute <- function (x) {
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
