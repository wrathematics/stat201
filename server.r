library("shiny")
library(ggplot2)


shinyServer(function(input, output){
  x <- reactive({
    seq(input$mean - 4*input$sd, input$mean + 4*input$sd, by=0.01)
  })
  
  df <- reactive({
    validate(
      need(input$sd > 0, "Standard Devaiation value must be > 0")
    )
    
    density <- dnorm(x(), mean=input$mean, sd=input$sd)
    data.frame(x=x(), y=density)
  })
  
  region <- reactive({
    if (input$areatype == "above")
      subset(df(), x > input$above)
    else if (input$areatype == "below")
      subset(df(), x < input$below)
    else if (input$areatype == "between")
      subset(df(), x > input$between_low & x < input$between_high)
    else if (input$areatype == "outside")
    {
      s <- subset(df(), x < input$outside_low | x > input$outside_high)
      cbind(s, group=ifelse(s$x < input$outside_low, 1, 2))
    }
  })
  
  area <- reactive({
    if (input$areatype == "above")
      auc <- pnorm(mean=input$mean, sd=input$sd, q=input$above, lower.tail=FALSE)
    else if (input$areatype == "below")
      auc <- pnorm(mean=input$mean, sd=input$sd, q=input$below)
    else if (input$areatype == "between")
      auc <- max(0, pnorm(mean=input$mean, sd=input$sd, q=input$between_high) - pnorm(mean=input$mean, sd=input$sd, q=input$between_low))
    else if (input$areatype == "outside")
      auc <- min(1, pnorm(mean=input$mean, sd=input$sd, q=input$outside_high, lower.tail=FALSE) + pnorm(mean=input$mean, sd=input$sd, q=input$outside_low))
    
    round(auc, digits=5)
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
        g + geom_ribbon(data=region(), aes(ymax=y, group=group), ymin=0, fill="#409FED", alpha=0.4)
      else
        g + geom_ribbon(data=region(), aes(ymax=y), ymin=0, fill="#409FED", alpha=0.4)
    }
    else
      g
  })
})

