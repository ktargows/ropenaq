######################################################################################
base_url <- function() {
  "https://api.openaq.org/v1/"
}

######################################################################################
buildQuery <- function(country = NULL, city = NULL, location = NULL,
                       parameter = NULL, has_geo = NULL, date_from = NULL,
                       date_to = NULL, value_from = NULL,
                       value_to = NULL, query){
  # country
  if (!is.null(country)) {
    if (!(country %in% countries()$code)) {
      stop("This country is not available within the platform.")
    }
    query <- paste0(query, "&country=", country)
  }

  # city
  if (!is.null(city)) {
    if (!is.null(country)) {
      if (!(city %in% cities(country = country)$cityURL)) {
        stop("This city is not available within the platform for this country.")# nolint
      }
    } else {
      if (!(city %in% cities()$cityURL)) {
        stop("This city is not available within the platform.")
      }
    }
    query <- paste0(query, "&city=", city)

  }

  # location
  if (!is.null(location)) {
    query <- paste0(query, "&location=", location)
    if (!is.null(country)) {
      if (!is.null(city)) {
        if (!(location %in%
              locations(country = country, city = city)$locationURL)) {
          stop("This location is not available within the platform for this country and this city.")# nolint
        }
      } else {
        if (!(location %in%
              locations(country = country)$locationURL)) {
          stop("This location is not available within the platform for this country.")# nolint
        }
      }

    }
    else {
      if (!is.null(city)) {
        if (!(location %in%
              locations(city = city)$locationURL)) {
          stop("This location is not available within the platform for this city.")# nolint
        }
      }
      else {
        if (!(location %in% locations()$locationURL)) {
          stop("This location is not available within the platform.")# nolint
        }
      }
    }
  }

  # parameter
  if (!is.null(parameter)) {
    if (!(parameter %in% c("pm25", "pm10", "so2",
                           "no2", "o3", "co", "bc"))) {
      stop("You asked for an invalid parameter: see list of valid parameters in the Arguments section of the function help")# nolint
    }


    locationsTable <- locations(country = country,
                                city = city,
                                location = location)
    if (sum(grepl(parameter, locationsTable$parameters)) == 0) {
      stop("This parameter is not available for any location corresponding to your query")# nolint
    }
    query <- paste0(query, "&parameter=", parameter)
  }

  # has_geo
  if (!is.null(has_geo)) {
    if (has_geo == TRUE) {
      query <- paste0(query, "&has_geo=1")
    }
    if (has_geo == FALSE) {
      query <- paste0(query, "&has_geo=false")
    }

  }


  # date_from
  if (!is.null(date_from)) {
    if (is.na(lubridate::ymd(date_from))) {
      stop("date_from and date_to have to be inputed as year-month-day")
    }
    query <- paste0(query, "&date_from=", date_from)
  }
  # date_to
  if (!is.null(date_to)) {
    if (is.na(lubridate::ymd(date_to))) {
      stop("date_from and date_to have to be inputed as year-month-day")
    }
    query <- paste0(query, "&date_to=", date_to)
  }

  # check dates
  if (!is.null(date_from) & !is.null(date_to)) {
    if (ymd(date_from) > ymd(date_to)) {
      stop("The start date must be smaller than the end date.")
    }

  }

  # value_from
  if (!is.null(value_from)) {
    if (value_from < 0) {
      stop("No negative value for value_from please!")
    }
    query <- paste0(query, "&value_from=", value_from)
  }

  # value_to
  if (!is.null(value_to)) {
    if (value_to < 0) {
      stop("No negative value for value_to please!")
    }
    query <- paste0(query, "&value_to=", value_to)
  }

  # check values
  if (!is.null(value_from) & !is.null(value_to)) {
    if (value_to < value_from) {
      stop("The max value must be bigger than the min value.")
    }

  }

  # if the last character is a "?" erase it
  splits <- strsplit(query, split = "")
  if (tail(splits[[1]], n = 1) == "\\?"){
    query <- gsub("\\?", "", query)
  }

  return(query)
}
######################################################################################
getResults <- function(query){
  page <- httr::GET(query)

  # convert the http error to a R error
  httr::stop_for_status(page)
  contentPage <- httr::content(page, as = "text")

  # parse the data
  resTable <- jsonlite::fromJSON(contentPage)$results
  resTable <- dplyr::tbl_df(resTable)
  return(resTable)
}

######################################################################################
addCityURL <- function(resTable){
  cityURL <- unlist(lapply(resTable$city,
                           URLencode,
                           reserved = TRUE))
  cityURL <- unlist(lapply(cityURL, gsub,
                           pattern = "\\%20",
                           replacement = "+"))
  resTable <- dplyr::mutate(resTable,
                               cityURL = cityURL)
  return(resTable)
}

addLocationURL <- function(resTable){
  locationURL <- unlist(lapply(resTable$location,
                           URLencode,
                           reserved = TRUE))
  locationURL <- unlist(lapply(locationURL, gsub,
                           pattern = "\\%20",
                           replacement = "+"))
  resTable <- dplyr::mutate(resTable,
                            locationURL = locationURL)
  return(resTable)
}
######################################################################################
addGeo <- function(resTable){
  if ("coordinates" %in% names(resTable)){
    longitude <- resTable$coordinates$longitude
    latitude <- resTable$coordinates$latitude
    resTable <- dplyr::select(resTable,
                              - coordinates)
  }
  else{
    longitude <- rep(NA, nrow(resTable))
    latitude <- rep(NA, nrow(resTable))
  }

  resTable <- dplyr::mutate(resTable,
                            longitude = longitude,
                            latitude = latitude)

  return(resTable)
}