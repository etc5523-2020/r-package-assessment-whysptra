#' @name valuebox
#' 
#' @title Refactor the ValueBoxOutput()
#'
#' @description This function will refactor the ValueBoxOutput() into a single function
#'
#' @param id The character vector of InputId
#'
#' @examples valuebox("confirmed")
#' valuebox("recovered")
#' valuebox("death")
#'
#'
#' @export
library(shinydashboard)
valuebox <- function(id){
  shinydashboard::valueBoxOutput(id, width=3)
} 