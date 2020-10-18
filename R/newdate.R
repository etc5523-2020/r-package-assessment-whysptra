#' @name newdate
#' 
#' @title Reactive function of southeast dataset
#'
#' @description This function refactor the reactive function that takes value from date range input 
#'
#'
#' @examples newdate(input)()
#'
#' @ @export
library(shiny)
library(dplyr)
newdate <- function(input){
  shiny::reactive({
   req(input$range)
  southeast %>% dplyr::filter(between(date, input$range[1], input$range[2]))
})
}