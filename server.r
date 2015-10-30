library("shiny")
library(ggplot2)


ndigits <- 5
round <- function(x) base::round(x, digits=ndigits)


shinyServer(function(input, output){
  ### Plot data
  x <- reactive({
    validate(
      need(!is.na(input$mean), "You must input a value for 'mean'."),
      need(input$sd > 0, "Standard Devaiation value must be > 0")
    )
    
    seq(input$mean - 4*input$sd, input$mean + 4*input$sd, by=0.01)
  })
  
  df <- reactive({
    density <- dnorm(x(), mean=input$mean, sd=input$sd)
    data.frame(x=x(), y=density)
  })
  
  areain <- reactive({
    validate(
      need(!is.na(input$areain), "You must input a value for 'area'.")
    )
    
    print(input$areain)
    input$areain
  })
  
  ### above/below/etc parameters
  above <- reactive({
    if (input$inputtype == "value")
      input$above
    else if (input$inputtype == "area")
      qnorm(mean=input$mean, sd=input$sd, areain(), lower.tail=FALSE)
  })
  
  below <- reactive({
    if (input$inputtype == "value")
      input$below
    else if (input$inputtype == "area")
      qnorm(mean=input$mean, sd=input$sd, areain())
  })
  
  between_low <- reactive({
    if (input$inputtype == "value")
      input$between_low
    else if (input$inputtype == "area")
      qnorm(.5 + areain()/2, mean=input$mean, sd=input$sd, lower.tail=FALSE)
  })
  
  between_high <- reactive({
    if (input$inputtype == "value")
      input$between_high
    else if (input$inputtype == "area")
      qnorm(.5 + areain()/2, mean=input$mean, sd=input$sd)
  })
  
  outside_low <- reactive({
    if (input$inputtype == "value")
      input$outside_low
    else if (input$inputtype == "area")
      qnorm(areain()/2, mean=input$mean, sd=input$sd)
  })
  
  outside_high <- reactive({
    if (input$inputtype == "value")
      input$outside_high
    else if (input$inputtype == "area")
      qnorm(areain()/2, mean=input$mean, sd=input$sd, lower.tail=FALSE)
  })
  
  
  ### Shading region
  region <- reactive({
    if (input$areatype == "above")
      subset(df(), x > above())
    else if (input$areatype == "below")
      subset(df(), x < below())
    else if (input$areatype == "between")
      subset(df(), x > between_low() & x < between_high())
    else if (input$areatype == "outside")
    {
      s <- subset(df(), x < outside_low() | x > outside_high())
      cbind(s, group=ifelse(s$x < outside_low(), 1, 2))
    }
  })
  
  area <- reactive({
    if (input$inputtype == 'area')
      areain()
    else
    {
      validate(
        need(!is.na(input$above), "You must input a value for 'above'."),
        need(!is.na(input$below), "You must input a value for 'below'."),
        need(!is.na(input$between_low), "You must input values for both 'between' entries."),
        need(!is.na(input$between_high), "You must input values for both 'between' entries."),
        need(!is.na(input$outside_low), "You must input values for both 'outside' entries."),
        need(!is.na(input$outside_high), "You must input values for both 'outside' entries.")
      )
      if (input$areatype == "above")
        auc <- pnorm(mean=input$mean, sd=input$sd, q=input$above, lower.tail=FALSE)
      else if (input$areatype == "below")
        auc <- pnorm(mean=input$mean, sd=input$sd, q=input$below)
      else if (input$areatype == "between")
        auc <- max(0, pnorm(mean=input$mean, sd=input$sd, q=input$between_high) - pnorm(mean=input$mean, sd=input$sd, q=input$between_low))
      else if (input$areatype == "outside")
        auc <- min(1, pnorm(mean=input$mean, sd=input$sd, q=input$outside_high, lower.tail=FALSE) + pnorm(mean=input$mean, sd=input$sd, q=input$outside_low))
      
      round(auc)
    }
  })
  
  output$areaout <- renderText(area())
  
  output$quantile <- renderText({
    if (input$areatype == "above")
      above()
    else if (input$areatype == "below")
      below()
    else if (input$areatype == "between")
      paste(round(between_low()), "and", round(between_high()))
    else if (input$areatype == "outside")
      paste(round(outside_low()), "and", round(outside_high()))
  })
  
  output$plot <- renderPlot({
    g <- ggplot(data=df(), aes(x, y)) +
      geom_line() + 
      theme_bw() + 
      ggtitle(paste0("Normal Distribution with Area=", area())) + 
      xlab("") + 
      ylab("")
    
    if (area() > 0)
    {
      if (input$areatype == "outside")
      {
#        labeldf <- data.frame(x=round(c(outside_low(), outside_high())), y=c(0, 0))
        g + 
          geom_ribbon(data=region(), aes(ymax=y, group=group), ymin=0, fill="#409FED", alpha=0.4)
#          geom_text(data=labeldf, aes(x=x, y=y, label=x))
      }
      else
        g + geom_ribbon(data=region(), aes(ymax=y), ymin=0, fill="#409FED", alpha=0.4)
    }
    else
      g
  })
})

