library("shiny")
library("ggplot2")

shinyUI(
  fluidPage(
    tags$head(
      tags$style(HTML("
        .shiny-output-error-validation {
          color: green;
        }
      "))
    ),
    
    
    headerPanel("Central Limit Theorem"),
    sidebarPanel(
      radioButtons(inputId="distr", label="Distribution", 
        choices=c("Normal", "Student's t", "Binomial", "Exponential")),
      
      conditionalPanel(condition="input.distr == 'Normal'",
        numericInput("norml_mean", "Mean", value=0),
        numericInput("norml_sd", "Standard Deviation", min=1, value=1)
      ),
      
      conditionalPanel(condition="input.distr == 'Student\\'s t'",
        numericInput("t_df", "Degrees of Freedom", min=0, value=1)
      ),
      
      conditionalPanel(condition="input.distr == 'Binomial'",
        numericInput("binom_prob", "Probability", min=0, max=1, value=.5)
      ),
      
      conditionalPanel(condition="input.distr == 'Exponential'",
        numericInput("exp_rate", "Rate", value=1)
      ),
      
      sliderInput(inputId="sampsize", label="Sample Size", min=1, max=100, value=10),
      sliderInput(inputId="ntrials", label="Number of Trials", min=2, max=1000, value=10),
      numericInput(inputId="seed", label="Seed", value=NA)
    ),
    mainPanel(
      plotOutput("dens_plot"),
      br(),
      plotOutput("means")
    )
  )
)

