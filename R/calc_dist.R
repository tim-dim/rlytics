

#' Distance in km. Input: data.frames with the column fr$lat, fr$lon, to$lat, to$lon
#'
#'
#' @rdname calc_dist
#' @references
#' Calculate distance in km
#'


#' @export
#' @rdname calc_dist
as_radians = function(theta=0){
  return(theta * pi / 180)
}

#' @export
#' @rdname calc_dist
#' @param fr dataframe of origin location(s), needs following columns: lat, lon
#' @param to dataframe of destination location(s), needs following columns: lat, lon

calc_dist = function(fr, to) {
  lat1 = as_radians(fr$lat)
  lon1 = as_radians(fr$lon)
  lat2 = as_radians(to$lat)
  lon2 = as_radians(to$lon)
  #a = 3963.191;
  #b = 3949.903;
  #kilometer
  a = 6378.138;
  b = 6356.753;
  numerator = ( a^2 * cos(lat2) )^2 + ( b^2 * sin(lat2) ) ^2
  denominator = ( a * cos(lat2) )^2 + ( b * sin(lat2) )^2
  radiusofearth = sqrt(numerator/denominator) #Accounts for the ellipticity of the earth.
  d = radiusofearth * acos( sin(lat1) * sin(lat2) + cos(lat1)*cos(lat2)*cos(lon2 - lon1) )
  d.return = list(distance=d)
  return(d.return)
}
