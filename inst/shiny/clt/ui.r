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
      selectInput(inputId="distr", label="Distribution", 
        choices=c("Normal", "Uniform", "Student's t", "F", "Binomial", "Exponential", "Cauchy", "Poisson", "Weibull")),
      
      conditionalPanel(condition="input.distr == 'Normal'",
        numericInput("norml_mean", "Mean", value=0),
        numericInput("norml_sd", "Standard Deviation", min=1, value=1)
      ),
      
      conditionalPanel(condition="input.distr == 'Uniform'",
        numericInput("unif_min", "Minimum", value=0),
        numericInput("unif_max", "Maximum", value=1)
      ),
      
      conditionalPanel(condition="input.distr == 'Student\\'s t'",
        numericInput("t_df", "Degrees of Freedom", min=0, value=1)
      ),
      
      conditionalPanel(condition="input.distr == 'F'",
        numericInput("f_df1", "df1", value=1, min=0),
        numericInput("f_df2", "df2", value=1, min=0)
      ),
      
      conditionalPanel(condition="input.distr == 'Binomial'",
        numericInput("binom_prob", "Probability", min=0, max=1, value=.5)
      ),
      
      conditionalPanel(condition="input.distr == 'Exponential'",
        numericInput("exp_rate", "Rate", value=1)
      ),
      
      conditionalPanel(condition="input.distr == 'Cauchy'",
        numericInput("cauchy_loc", "Location", value=0),
        numericInput("cauchy_scl", "Scale", min=0, value=1)
      ),
      
      conditionalPanel(condition="input.distr == 'Poisson'",
        numericInput("pois_rate", "Rate", min=0, value=1)
      ),
      
      conditionalPanel(condition="input.distr == 'Weibull'",
        numericInput("weibull_shape", "Shape", min=0, value=1),
        numericInput("weibull_scale", "Scale", min=0, value=1)
      ),
      
      
      
      sliderInput(inputId="sampsize", label="Sample Size", min=1, max=250, value=10),
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

