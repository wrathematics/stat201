#' normalApp
#' 
#' Run the normal distribution app.
#'
#' @export
normalApp <- function()
{
  shiny::runApp(file.path(system.file("shiny/normal", package="stat201")))
}



#' clt
#' 
#' Run the central limit theorem app.
#'
#' @export
cltApp <- function()
{
  shiny::runApp(file.path(system.file("shiny/clt", package="stat201")))
}
