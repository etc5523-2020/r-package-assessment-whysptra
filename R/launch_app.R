#' Launch the Covid-19 shiny application
#'
#' @description This function will find and load the shiny application from inst/app.
#'
#' @param x shiny app name
#'
#' @return
#'
#' @examples
#'
#'launch_app()
#'
#' @export
#' 
library(shiny)

launch_app <- function(x){
    shiny::runApp(appDir = "inst/app")
  }
