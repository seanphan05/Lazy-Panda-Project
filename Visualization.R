# Data visualization function:
vis <- function(train.data, test.data, tar.loc.train, tar.loc.test)
{
  # summarize dataset
  sum.train <- summary(train.data)
  sum.test  <- summary(test.data)
  sum.data  <- list("summary.train.data"=sum.train, "summary.test.data"=sum.test)
  
  # create ggplot_missing function to map missing values:
  remove.packages("ggplot2")
  install.packages('ggplot2', dependencies = TRUE)
  library(reshape2)
  library(dplyr)
  library(ggplot2)
  ggplot_missing <- function(x){
    x %>% is.na %>% melt %>% ggplot(data = ., aes(x = Var2, y = Var1)) +
      geom_raster(aes(fill = value)) +
      scale_fill_grey (name = '', labels = c('Present', 'Missing')) +
      theme_minimal() +
      theme(axis.text.x = element_text(angle = 45, vjust = 0.5)) +
      labs(x = 'Variables on Dataset', y = 'Rows / Observations') }
      # map missing values for train data:
        vis.train <- ggplot_missing(train.data)
        num.miss.train <- sapply(train.data,function(x) sum(is.na(x)))
      # map missing values for test data:
        vis.test <- ggplot_missing(test.data)
        num.miss.test <- sapply(test.data,function(x) sum(is.na(x)))
        
  miss.vis <- list("vis.train"=vis.train, "vis.test"=vis.test,
                   "num.train"=num.miss.train, "num.test"=num.miss.test)
  
  # histogram of Target variable
  if (is.numeric(train.data[tar.loc.train])) { histo <- hist(train.data[tar.loc.train]) }
  else {histo = NULL}
 
  # exploring relationships among features: correlation matrix
  tar.name.train     <- names(train.data[tar.loc.train])
  class.train        <- lapply(train.data[-tar.loc.train], class)
  {
  if (any(class.train=="factor")) {
      char.name.train  <- names(which(class.train=="factor"))
      char.loc.train   <- match(char.name.train, names(train.data))
      numeric.col      <- names(train.data[-c(char.loc.train, tar.loc.train)]) }
    else {
      numeric.col      <- names(train.data[-tar.loc.train]) }
  }
  matrix.cor <- cor(train.data[numeric.col])
  
  # visualing relationships among features: scatterplot matrix
  col <- c("blue", "red")
  pairs(train.data[numeric.col],col = col, cex.labels = 1.5, lower.panel = NULL, pch=19, cex = 1)
  p1 <- recordPlot()

  # more informative scatterplot matrix
  library(psych)
  pairs.panels(train.data[numeric.col])
  p2 <- recordPlot()
  
  return(list("summary"=sum.data, "missing.value"=miss.vis, "histogram"=histo, 
              "matrix.correlation"=matrix.cor, "scatter.plot1"=p1, "scatter.plot2"=p2))
}