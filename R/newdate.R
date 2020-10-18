#' @name newdate
#' 
#' @title Reactive function of southeast dataset
#'
#' @description This function refactor the reactive function that takes value from date range input 
#'
#'
#' @ @export
library(shiny)
library(dplyr)
newdate <- function(input){
  shiny::reactive({
   shiny::req(input$range)
  southeastcovid::southeast %>% dplyr::filter(dplyr::between(date, input$range[1], input$range[2]))
})
}