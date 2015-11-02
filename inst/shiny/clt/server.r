library("shiny")
library(ggplot2)


ndigits <- 5
round <- function(x) base::round(x, digits=ndigits)


shinyServer(function(input, output){
  output$dens_plot <- renderPlot({
    if (input$distr == "Normal")
    {
      mean <- input$norml_mean
      sd <- input$norml_sd
      
      x <- seq(mean - 4*sd, mean + 4*sd, by=0.1)
      dens <- dnorm(x, mean=mean, sd=sd)
    }
    else if (input$distr == "Student's t")
    {
      x <- seq(-4, 4, by=0.1)
      dens <- dt(x, df=input$t_df)
    }
    else if (input$distr == "Binomial")
    {
      hist(dbinom(c(0, 1), size=1, prob=input$binom_prob), xlab="", xlim=c(0, 1), main="")
    }
    else if (input$distr == "Exponential")
    {
      x <- seq(0, 3, by=0.1)
      dens <- dexp(x, rate=input$exp_rate)
    }
    else if (input$distr == "Cauchy")
    {
      loc <- input$cauchy_loc
      scl <- input$cauchy_scl
      
      x <- seq(loc - 4*scl, loc + 4*scl, by=0.1)
      dens <- dcauchy(x, location=loc, scale=scl)
    }
    
    
    if (input$distr != "Binomial")
      plot(x, dens, type="l", xlab="", ylab="")
    
    title("Sampling Distribution")
  })
  
  output$means <- renderPlot({
    if (!is.na(input$seed))
      set.seed(input$seed)
    
    if (input$distr == "Normal")
      rdensfun <- function(n) rnorm(n, mean=input$norml_mean, sd=input$norml_sd)
    else if (input$distr == "Student's t")
      rdensfun <- function(n) rt(n, df=input$t_df)
    else if (input$distr == "Binomial")
      rdensfun <- function(n) rbinom(n, size=1, prob=input$binom_prob)
    else if (input$distr == "Exponential")
      rdensfun <- function(n) rexp(n, rate=input$exp_rate)
    else if (input$distr == "Cauchy")
      rdensfun <- function(n) rcauchy(n, location=input$cauchy_loc, scale=input$cauchy_scl)
    
    means <- sapply(1:input$ntrials, function(.) mean(rdensfun(input$sampsize)))
    hist(means, xlab="Mean", main="Distribution of Sample Means")
  })
  
})

