#' @name valueboxprint
#' 
#' @title Refactor the renderValueBox()
#'
#' @description This function will refactor the renderValuebox into a single function thaht can be called within the app
#'
#' @param input The input argument (default)
#' @param df A dataset which want to summarise (a reactive dataset from newdate function)
#' @param x The number of column from x that contains values
#' @param label A character vector subtitle that we want to show in value box ("confirmed, death, recovered")
#' @param colors A character vector of the available colors (Valid colors are: red, yellow, aqua, blue, light-blue, green, navy, teal, olive, lime, orange, fuchsia, purple, maroon, black.)
#'
#' @importFrom magrittr %>%
#' 
#'
#' @examples valueboxprint(input = input, df = newdate(input)(), x = 7, label = "recovered", colors = "aqua")
#' @export
library(dplyr)
library(shinydashboard)
library(tidyr)
library(magrittr)

valueboxprint <- function(input, df, x, label, colors){
  shinydashboard::renderValueBox({
    shiny::req(input$country_choice)
    
    case <- dplyr::filter(df, country %in% c(input$country_choice)) %>%
    tidyr::pivot_wider(names_from = "type", values_from = "cases")
    
    y <- case[,x]
    
    newcase <- case %>% dplyr::summarise(total_confirmed = format(
      sum(y, na.rm = TRUE),
      big.mark = ",",
      scientific = FALSE
    ))
  shinydashboard::valueBox(value = newcase, subtitle= paste("Total", label), color = paste(colors))
})
}