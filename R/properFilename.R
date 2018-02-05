

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
