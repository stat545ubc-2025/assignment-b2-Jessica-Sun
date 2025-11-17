#' Splitting review into overall rating, # of reviews, and % of positive reviews
#'
#' This function splits a column of review data derived from the steam_games data
#' set into three pieces of data via delimiters. These pieces are:
#'  - "_rating": Overall rating of game. String. Ex: Positive, Negative, Mixed.
#'  - "_reviews": Number of reviews game received. Numeric. Ex: 183, 18, 67392.
#'  - "percent_positive_": % of reviews that are positive. Numeric. Ex: 98, 12, 3.
#'
#' It is expected that the review data is formatted with specific delimiters
#' present in the steam_games data.
#'
#' @param data A tibble of data with a column whose name includes "_reviews".
#'             The data should be formatted like in steam_games.
#'             Named because it's a tibble of data.
#' @param time A string indicating review column to split. Ex: "all", "recent".
#'             This string will be appended to the start of the "_rating" and
#'             "_reviews" names, and the end of the "percent_positive_" name.
#'             Named because it indicates what time the data is from.
#'
#' @return A tibble with the same columns as param data, except the chosen
#'         "_reviews" column has been split into "_ratings", "_reviews", and
#'          "percent_positive".
#'
#' @examples
#' split_steam_reviews(steam_games, "recent")
#' split_steam_reviews(steam_games, "all")
#'
#' @export split_steam_reviews

split_steam_reviews <- function(data, time){
  # data: Tibble including column to split
  # time: String indicating which column to split

  # Delimiters to separate the string at
  delims = list(",(", "),-", "%")

  # Name of column to split
  col_name = paste(time, "reviews", sep = "_")

  # Names of columns to check
  ratings = paste(time, "rating", sep = "_")
  percent = paste("percent_positive", time, sep = "_")
  check_list = list(ratings, percent)

  # Check if data set has appropriate column
  if(!(col_name %in% names(data))){
    stop("data does not contain the required column")
  }

  # Check if data was already split before.
  if(length(intersect(check_list, names(data))) != 0){
    stop("data has already been split before")
  }

  # For each delimiter, separate the string
  for(i in 1:length(delims)){
    data <- separate_wider_delim(data, sym(!!col_name), delim = delims[[i]],
                                 names = c(paste("x", as.character(i), sep = "_"),
                                           col_name),
                                 too_many = "merge", too_few = "align_start")
  }

  # Remove extraneous data
  data <- data %>%
    select(-!!col_name) %>%

    # Remove NaN values in rating
    mutate(x_1 = na_if(x_1, "NaN")) %>%

    # Format ratings where not enough people reviewed to form a consensus
    mutate(x_2 = if_else(grepl("user", x_1), x_1[1], x_2)) %>%

    # Format ratings that don't have positive/mixed/negative tag
    mutate(x_1 = if_else(grepl("Positive|Mixed|Negative", x_1), x_1, NA)) %>%

    # Remove columns that have the wrong class of characters
    mutate(x_1 = if_else(grepl("[0-9]", x_1), NA, x_1)) %>%
    mutate(x_2 = if_else(grepl("[A-Za-z]", x_2), NA, x_2)) %>%
    mutate(x_3 = if_else(grepl("[A-Za-z]", x_3), NA, x_3))

  # Check if initial column was formatted right
  if(sum(!is.na(data$x_1)) == 0 || sum(!is.na(data$x_2)) == 0 ||
     sum(!is.na(data$x_3)) == 0){
    stop("strings in column isn't formatted properly")
  }

  # Remove commas and format numbers
  data <- data %>%
    mutate(x_2 = as.numeric(gsub(",", "", x_2))) %>%
    mutate(x_3 = as.numeric(x_3)) %>%

    # Rename the columns
    rename(!!ratings := x_1, !!col_name := x_2, !!percent := x_3)

  return(data)
}
