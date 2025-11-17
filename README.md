
<!-- README.md is generated from README.Rmd. Please edit that file -->

# SteamGamesReviewFilter

<!-- badges: start -->

<!-- badges: end -->

The goal of SteamGamesReviewFilter is to split a column of review data
derived from the `steam_games` data set into three pieces of data via
delimiters. These pieces are:

\- `_rating`: Overall rating of game. String. Ex: Positive, Negative,
Mixed.

\- `_reviews`: Number of reviews game received. Numeric. Ex: 183, 18,
67392.

\- `percent_positive_`: % of reviews that are positive. Numeric. Ex: 98,
12, 3.

It is expected that the review data is formatted with specific
delimiters present in the `steam_games` data.

## Installation

You can install the development version of SteamGamesReviewFilter from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("stat545ubc-2025/assignment-b2-Jessica-Sun")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(SteamGamesReviewFilter)
library(datateachr)
library(tidyverse)
#> ── Attaching core tidyverse packages ──────────────────────── tidyverse 2.0.0 ──
#> ✔ dplyr     1.1.4     ✔ readr     2.1.5
#> ✔ forcats   1.0.0     ✔ stringr   1.5.2
#> ✔ ggplot2   3.5.2     ✔ tibble    3.3.0
#> ✔ lubridate 1.9.4     ✔ tidyr     1.3.1
#> ✔ purrr     1.1.0     
#> ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
#> ✖ dplyr::filter() masks stats::filter()
#> ✖ dplyr::lag()    masks stats::lag()
#> ℹ Use the conflicted package (<http://conflicted.r-lib.org/>) to force all conflicts to become errors
library(stringr)
library(forcats)

split_steam_reviews(steam_games, "recent")
#> # A tibble: 40,833 × 23
#>       id url               types name  desc_snippet recent_rating recent_reviews
#>    <dbl> <chr>             <chr> <chr> <chr>        <chr>                  <dbl>
#>  1     1 https://store.st… app   DOOM  Now include… Very Positive            554
#>  2     2 https://store.st… app   PLAY… PLAYERUNKNO… Mixed                   6214
#>  3     3 https://store.st… app   BATT… Take comman… Mixed                    166
#>  4     4 https://store.st… app   DayZ  The post-so… Mixed                    932
#>  5     5 https://store.st… app   EVE … EVE Online … Mixed                    287
#>  6     6 https://store.st… bund… Gran… Grand Theft… <NA>                      NA
#>  7     7 https://store.st… app   Devi… The ultimat… Very Positive            408
#>  8     8 https://store.st… app   Huma… Human: Fall… Very Positive            629
#>  9     9 https://store.st… app   They… They Are Bi… Very Positive            192
#> 10    10 https://store.st… app   Warh… In a world … <NA>                      NA
#> # ℹ 40,823 more rows
#> # ℹ 16 more variables: percent_positive_recent <dbl>, all_reviews <chr>,
#> #   release_date <chr>, developer <chr>, publisher <chr>, popular_tags <chr>,
#> #   game_details <chr>, languages <chr>, achievements <dbl>, genre <chr>,
#> #   game_description <chr>, mature_content <chr>, minimum_requirements <chr>,
#> #   recommended_requirements <chr>, original_price <dbl>, discount_price <dbl>
split_steam_reviews(steam_games, "all")
#> # A tibble: 40,833 × 23
#>       id url      types name  desc_snippet recent_reviews all_rating all_reviews
#>    <dbl> <chr>    <chr> <chr> <chr>        <chr>          <chr>            <dbl>
#>  1     1 https:/… app   DOOM  Now include… Very Positive… Very Posi…       42550
#>  2     2 https:/… app   PLAY… PLAYERUNKNO… Mixed,(6,214)… Mixed           836608
#>  3     3 https:/… app   BATT… Take comman… Mixed,(166),-… Mostly Po…        7030
#>  4     4 https:/… app   DayZ  The post-so… Mixed,(932),-… Mixed           167115
#>  5     5 https:/… app   EVE … EVE Online … Mixed,(287),-… Mostly Po…       11481
#>  6     6 https:/… bund… Gran… Grand Theft… NaN            <NA>                NA
#>  7     7 https:/… app   Devi… The ultimat… Very Positive… Very Posi…        9645
#>  8     8 https:/… app   Huma… Human: Fall… Very Positive… Very Posi…       23763
#>  9     9 https:/… app   They… They Are Bi… Very Positive… Very Posi…       12127
#> 10    10 https:/… app   Warh… In a world … <NA>           Mixed              904
#> # ℹ 40,823 more rows
#> # ℹ 15 more variables: percent_positive_all <dbl>, release_date <chr>,
#> #   developer <chr>, publisher <chr>, popular_tags <chr>, game_details <chr>,
#> #   languages <chr>, achievements <dbl>, genre <chr>, game_description <chr>,
#> #   mature_content <chr>, minimum_requirements <chr>,
#> #   recommended_requirements <chr>, original_price <dbl>, discount_price <dbl>
```
