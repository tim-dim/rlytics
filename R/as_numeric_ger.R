


#' Converts german type to english
#'
#'
#' @rdname as.numeric.ger
#' @references
#' Converts german style to english style
#'


#' @export
#' @rdname as.numeric.ger
as.numeric_ger = function(x){
  as.numeric(gsub(",", ".", gsub("\\.", "", as.character(x))))
}
