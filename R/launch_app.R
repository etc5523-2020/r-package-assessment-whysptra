#' @name launch_app
#' 
#' @title Launch the Covid-19 shiny application
#'
#' @description This function will find and load the shiny application from inst/app.
#'
#'
#' @examples launch_app()
#'
#' @source The dataset from the application comes from Ramikripsin coronavirus package
#'
#' @export
#' 
library(shiny)

launch_app <- function(){
    shiny::runApp(appDir = "inst/app")
  }
