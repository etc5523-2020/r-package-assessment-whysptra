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

launch_app <- function(){
   appDir <- system.file("app", package="southeastcovid")
   if (appDir == ""){
     stop("Could not find the directory, please re-install southeastcovid")
   }
  shiny::runApp(appDir, display.mode = "normal")
  }
