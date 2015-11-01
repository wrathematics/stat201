#' Run the Text Gateway App
#'
#' @export
stat201 <- function()
{
  shiny::runApp(file.path(system.file("shiny", package="stat201")))
}
