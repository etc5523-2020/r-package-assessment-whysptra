## code to prepare `southeast` dataset goes here

#' Coronavirus cases dataset in South East Asia
#'
#' Data from `coronavirus` CRAN package which contain date, country, lat, lon, type and cases.
#' The data start from 2020-01-22 until 2020-09-25
#' 
#' @format A data frame with 7440 rows and 6 variables:
#' \describe{
#'   \item{date}{date of cases}
#'   \item{country}{country in south east asia}
#'   \item{lat}{latitude}
#'   \item{lon}{longitude}
#'   \item{type}{type of cases consist of confirmed, death, and recovered}
#'   \item{cases}{number of cases}
#'
#' @docType data
#'
#' @usage data(southeast)
#' @alias {southeast}
#'
#' @keywords datasets
#'
#' @references Rami Krispin and Jarrett Byrnes (2020). coronavirus: The 2019 Novel Coronavirus COVID-19
#`(2019-nCoV) Dataset. R package version 0.3.0.9000.
#' (\href{https://github.com/RamiKrispin/coronavirus})
#'
#' @source \href{https://github.com/RamiKrispin/coronavirus}
#'
#' @examples
#' data(southeast)
#' southeast$country
#' southeast$date

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