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
    
    
    titlePanel("Normal Distribution"),
    plotOutput("plot"),
    hr(),
    
    
    fluidRow(
      column(3,
        radioButtons("inputtype", label=h3("Input Type"),
            choices=list("Area from a value"="value", "Value from an area"="area"), 
            selected="value")
      ),
      column(2,
        br(),br(),
        conditionalPanel(condition="input.inputtype == 'value'",
          h5(strong("Area")),
          uiOutput("areaout")
        ),
        conditionalPanel(condition="input.inputtype == 'area'",
          numericInput(inputId="areain", label="Area", min=0, max=1, step=0.1, value=0.025)
        )
      )
    ),
    
    
    fluidRow(
      column(2,
        numericInput(inputId="mean", label="Mean", value=0),
        numericInput(inputId="sd", label="SD", min=0, step=1, value=1)
      ),
      
      column(2,
        radioButtons("areatype", label=h3("Area Type"),
          choices=list("Above"="above", "Below"="below", "Between"="between", "Outside"="outside"), 
          selected="above")
      ),
      
      column(5,
        conditionalPanel(condition="input.inputtype == 'value'",
          conditionalPanel(condition="input.areatype == 'above'",
            numericInput(inputId="above", label="Above", value=1.96)
          ),
          
          conditionalPanel(condition="input.areatype == 'below'",
            numericInput(inputId="below", label="Below", value=-1.96)
          ),
          
          conditionalPanel(condition="input.areatype == 'between'",
            column(4,
              numericInput(inputId="between_low", label="Lower", value=-1.96)
            ),
            column(4,
              numericInput(inputId="between_high", label="Upper", value=1.96)
            )
          ),
          
          conditionalPanel(condition="input.areatype == 'outside'",
            column(4,
              numericInput(inputId="outside_low", label="Lower", value=-1.96)
            ),
            column(4,
              numericInput(inputId="outside_high", label="Upper", value=1.96)
            )
          )
        ),
        
        conditionalPanel(condition="input.inputtype == 'area'",
          conditionalPanel(condition="input.areatype == 'above'",
            h5(strong("Above"))
          ),
          conditionalPanel(condition="input.areatype == 'below'",
            h5(strong("Below"))
          ),
          conditionalPanel(condition="input.areatype == 'between'",
            h5(strong("Between"))
          ),
          conditionalPanel(condition="input.areatype == 'outside'",
            h5(strong("Outside"))
          ),
          uiOutput("quantile")
        )
      )
    )
  )
)

