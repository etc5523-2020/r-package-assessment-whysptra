#' @name launch_app
#' 
#' @title Launch the Covid-19 shiny application
#'
#' @description This function will find and load the shiny application from inst/app.
#'
#'
#' @source The dataset from the application comes from Ramikripsin coronavirus package
#'
#' @examples
#'\dontrun{
#'launch_app()
#' }
#'
#' @export
#' 
library(shiny)
library(here)

launch_app <- function(){
  dir <- getwd()
  shiny::runApp(appDir = paste0(dir, paste0("/inst/app")))
  }
