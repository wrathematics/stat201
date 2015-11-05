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
    else if (input$distr == "Uniform")
    {
      min <- input$unif_min
      max <- input$unif_max
      validate(
        need(min <= max, "The minimum needs to be less than the maximum.")
      )
      
      x <- seq(min, max, by=0.01*(max-min))
      dens <- dunif(x, min=min, max=max)
    }
    else if (input$distr == "Student's t")
    {
      x <- seq(-4, 4, by=0.1)
      dens <- dt(x, df=input$t_df)
    }
    else if (input$distr == "F")
    {
      df1 <- input$f_df1
      df2 <- input$f_df2
      validate(
        need(df1>0 && df2>0, "The degrees of freedom parameters must be >0.")
      )
      
      x <- seq(0, 5, by=0.01)
      dens <- df(x, df2, df2)
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
    else if (input$distr == "Poisson")
    {
      validate(
        need(input$pois_rate > 0, "Rate must be > 0.")
      )
      
      x <- sort(rpois(5000, lambda=input$pois_rate))
      dens <- dpois(x, lambda=input$pois_rate)
    }
    else if (input$distr == "Weibull")
    {
      shape <- input$weibull_shape
      scale <- input$weibull_scale
      
      validate(
        need(shape > 0, "Shape must be > 0."),
        need(scale > 0, "Scale must be > 0.")
      )
      
      # don't know a better way tbh
      x <- sort(rweibull(1000, shape=shape, scale=scale))
      dens <- dweibull(x, shape=shape, scale=scale)
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
    else if (input$distr == "Uniform")
      rdensfun <- function(n) runif(n, min=input$unif_min, max=input$unif_max)
    else if (input$distr == "Student's t")
      rdensfun <- function(n) rt(n, df=input$t_df)
    else if (input$distr == "F")
      rdensfun <- function(n) rf(n, df1=input$f_df1, df2=input$f_df2)
    else if (input$distr == "Binomial")
      rdensfun <- function(n) rbinom(n, size=1, prob=input$binom_prob)
    else if (input$distr == "Exponential")
      rdensfun <- function(n) rexp(n, rate=input$exp_rate)
    else if (input$distr == "Cauchy")
      rdensfun <- function(n) rcauchy(n, location=input$cauchy_loc, scale=input$cauchy_scl)
    else if (input$distr == "Poisson")
      rdensfun <- function(n) rpois(n, lambda=input$pois_rate)
    else if (input$distr == "Weibull")
      rdensfun <- function(n) rweibull(n, shape=input$weibull_shape, scale=input$weibull_scale)
    
    means <- sapply(1:input$ntrials, function(.) mean(rdensfun(input$sampsize)))
    hist(means, xlab="Mean", main="Distribution of Sample Means")
  })
  
})

