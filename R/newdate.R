#' @export
newdate <- function(input){
  reactive({
   req(input$range)
  southeast %>% filter(between(date, input$range[1], input$range[2]))
})
}