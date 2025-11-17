test_that("Function splits data properly", {
  # Test that it can split both recent_reviews and all_reviews

  # Split data manually. Copied from Mini Data Analysis 2
  compare_data <-steam_games %>%
    select(name, all_reviews) %>%
    separate_wider_delim(all_reviews, delim = ",", names = c("all_rating",
                                                             "all_reviews"),
                         too_many = "merge", too_few = "align_start") %>%
    separate_wider_delim(all_reviews, delim = "(",
                         names = c("x", "all_reviews"),
                         too_many = "merge", too_few = "align_start") %>%
    separate_wider_delim(all_reviews, delim = "),- ",
                         names = c("all_reviews", "y"),
                         too_many = "merge", too_few = "align_start") %>%
    separate_wider_delim(y, delim = "%", names = c("percent_positive_all", "z"),
                         too_many = "merge", too_few = "align_start") %>%
    select(-x, -z) %>%
    mutate(all_reviews = suppressWarnings(as.numeric(gsub(",", "",
                                                          all_reviews)))) %>%
    mutate(percent_positive_all =
             suppressWarnings(as.numeric(percent_positive_all))) %>%

    # Format ratings where not enough people reviewed for a consensus.
    mutate(all_rating = if_else(grepl("NaN", all_rating), NA, all_rating)) %>%
    mutate(all_reviews = if_else(grepl("user", all_rating),
                                 suppressWarnings(as.numeric(all_rating[1])),
                                 all_reviews)) %>%
    mutate(all_rating = if_else(grepl("user", all_rating), NA, all_rating))

  expect_test_4 <- select(steam_games, name, all_reviews)

  expect_equal(split_steam_reviews(expect_test_4, "all"), compare_data)

  # Test that it can split a new column that's not "all" or "recent"
  expect_test_5 <- expect_test_4 %>%
    mutate(expect_test_4, new_reviews = all_reviews) %>%
    split_steam_reviews("new") %>%
    split_steam_reviews("all")

  expect_true((identical(expect_test_5$all_rating, expect_test_5$new_rating)
               && identical(expect_test_5$all_reviews, expect_test_5$new_reviews)
               && identical(expect_test_5$percent_positive_all,
                            expect_test_5$percent_positive_new)))
})
