test_that("Function returns the correct errors", {
  # Test that it outputs error if there's no _review column
  expect_test_1 <- select(steam_games, name, recommended_requirements)
  expect_error(split_steam_reviews(expect_test_1, "all"),
               "data does not contain the required column")

  # Test that it outputs error if the data is not formatted properly
  expect_test_2 <- rename(expect_test_1,
                          all_reviews = recommended_requirements)
  expect_error(split_steam_reviews(expect_test_2, "all"),
               "strings in column isn't formatted properly")

  # Test that it outputs error if the data has been split already
  expect_test_3 <- split_steam_reviews(steam_games, "all")
  expect_error(split_steam_reviews(expect_test_3, "all"),
               "data has already been split before")
})
