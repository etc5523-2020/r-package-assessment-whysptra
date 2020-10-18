## code to prepare `southeast` dataset goes here

library(coronavirus)
library(dplyr)
library(magrittr)

southeast <- coronavirus::coronavirus %>%
  dplyr::filter(
    country %in% c(
      "Indonesia",
      "Singapore",
      "Malaysia",
      "Thailand",
      "Laos",
      "Vietnam",
      "Philippines",
      "Myanmar",
      "Cambodia",
      "Brunei",
      "Timor-Leste"
    ),
    date <= "2020-09-25"
  ) %>%
  select(-province) %>%
  drop_na()

usethis::use_data(southeast, overwrite = TRUE)