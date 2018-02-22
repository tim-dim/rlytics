

#' Crawl google places for location types
#'
#'
#' @rdname crawl_google_places
#' @references
#' Crawl google places for location types
#' @param store_locations store-dataframe for which you crawl locations, with following structure: store_id, lat, lon
#' @param radius radius of the crawl in meters, default = 500m
#' @param api_key your google places api key
#' @param index your starting row for the crawl


#' @export
#' @rdname crawl_google_places
#'
#'


crawl_google_places <-


  function(store_locations, radius=500, api_key, index = 1) {



  store_location_sorroundings = data.table()
  pb <- txtProgressBar(min = index, max = nrow(store_locations), style = 3)

  for (i in index:nrow(store_locations)){

    # update progress bar
    setTxtProgressBar(pb, i)



    results = data.table()
    for (j in index:length(relevant_types)){

      # wait short time
      Sys.sleep(runif(1, 0.68, 1.25))

      # get first page
      ########################
      google_place_response = fromJSON(
        paste("https://maps.googleapis.com/maps/api/place/nearbysearch/json?",
              "location=",
              store_locations$lat[i],
              ",",
              store_locations$lon[i],
              "&radius=",
              radius,
              #"&rankby=",
              #"distance",
              "&type=",
              relevant_types[j],
              "&key=",
              api_key,
              sep=""
        )
      )

      # wait short time
      Sys.sleep(runif(1, .6, 1.1))

      if(length(google_place_response$results)==0){
        next
      }

      result = data.table(
        lat_loc = google_place_response$results$geometry$location$lat,
        lon_loc = google_place_response$results$geometry$location$lng,
        name = google_place_response$results$name,
        type = google_place_response$results$types,
        address = google_place_response$results$vicinity
      )
      # get next pages
      ########################
      next_page_token = google_place_response$next_page_token
      while(!is.null(next_page_token)){

        google_place_response = fromJSON(
          paste("https://maps.googleapis.com/maps/api/place/nearbysearch/json?",
                "&key=",
                api_key,
                "&pagetoken=",
                next_page_token,
                sep=""
          )
        )

        if(length(google_place_response$results)==0){
          break
        }

        result = result %>%
          rbind(
            data.table(
              lat_loc = google_place_response$results$geometry$location$lat,
              lon_loc = google_place_response$results$geometry$location$lng,
              name = google_place_response$results$name,
              type = google_place_response$results$types,
              address = google_place_response$results$vicinity
            )
          )

        if(is.null(google_place_response$next_page_token)){
          next_page_token = NULL
        } else{
          next_page_token = google_place_response$next_page_token
        }

        # wait short time
        Sys.sleep(runif(1, .5, .93))
      }

      results = results %>%
        rbind(result)
    }
    if(nrow(results)>1){
      results = results[!duplicated(results[,-"type"]),]

      # Eindeutigen Bezeichner für Stores (lat_nkd, lon_nkd) einfügen
      results$store_id = store_locations$store_id[i]
      results$lat = store_locations$lat[i]
      results$lon = store_locations$lon[i]

      store_location_sorroundings = store_location_sorroundings %>%
        rbind(results)
    } else {
      print(paste("ERROR, No Store or Restaurant, etc. found within radius for index", i, sep=": "))
    }
  }


  return(store_location_sorroundings)
}

