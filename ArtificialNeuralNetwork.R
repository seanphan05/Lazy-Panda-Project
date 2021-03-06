# Modeling data with Artificial Neural Network (ANN) algorithms:
ann <- function(norm.train, norm.test)
{
  if (class(norm.train$Target)=="factor") # use ANN for classification
  {
  library(gmodels) # confusion matrix use
  # install.packages("h2o")
  library(h2o)
  h2o.init(nthreads=8, max_mem_size="2G")
  h2o.removeAll() 
  h2o.init()
  # split train data for validation
  train.hex <- as.h2o(norm.train)
  test.hex  <- as.h2o(norm.test)
  splits    <- h2o.splitFrame(train.hex, 0.8, seed=777)
  split.train  <- h2o.assign(splits[[1]], "train.hex") # 80%
  split.valid  <- h2o.assign(splits[[2]], "valid.hex") # 20%
  dl.model     <- h2o.deeplearning(x=2:20,
                                   y="Target",
                                   training_frame=split.train,
                                   validation_frame=split.valid,
                                   activation = "Tanh", 
                                   hidden = c(200,200),
                                   variable_importances=T)
  dl.model.predict <- h2o.predict(dl.model, test.hex)
  dl.result        <- as.data.frame(dl.model.predict)
  h2o.shutdown(prompt=FALSE)
  
  # Confusion Matrix
  ConMax.nn <- CrossTable(norm.test$Target, dl.result$predict,
                          prop.chisq = FALSE, prop.c = FALSE, prop.r = FALSE,
                          dnn = c('actual Target', 'predicted Target'))
  
  # accuracy
  table.NN    <- table(norm.test$Target, dl.result$predict)
  nn.accuracy = round(sum(diag(table.NN)/sum(table.NN)),digits=5)
  nn.accuracy
  
  return(paste("Target variable had been classified with the accuracy of", nn.accuracy))
  } 
  
  else # use ANN for numeric prediction
  {
    # collecting attribute names from dataset
    n <- names(norm.train)
    # set up the formula
    f <- as.formula(paste("Target ~", paste(n[!n %in% "Target"], collapse = " + ")))
    # apply Neural Network
    library(neuralnet)
    
    # Logistic activation function:
    log.model <- neuralnet(f, data = norm.train, hidden = 1,
                          act.fct = "logistic", linear.output = FALSE)
    log.result <- compute(log.model, norm.test[-1])
    log.pred   <- log.result$net.result
    log.res    <- log.pred-norm.test$Target
    log.cor    <- cor(log.pred, norm.test$Target)
    log.MSE    <- mean(log.res^2)
    
    # Hyperbolic Tangent activation function:
    tanh.model <- neuralnet(f, data = norm.train, hidden = 1,
                           act.fct = "tanh", linear.output = FALSE)
    tanh.result <- compute(tanh.model, norm.test[-1])
    tanh.pred   <- tanh.result$net.result
    tanh.res    <- tanh.pred-norm.test$Target
    tanh.cor    <- cor(tanh.pred, norm.test$Target)
    tanh.MSE    <- mean(tanh.res^2)
    
    { # start compare between two activation function
    if (log.MSE < tanh.MSE)
    {
      best.MSE <- round(log.MSE,digits=5)
      best.cor <- round(log.cor,digits=5)
      best.act <- "Logistic"}
    else
    {
      best.MSE <- round(tanh.MSE,digits=5)
      best.cor <- round(tanh.cor,digits=5)
      best.act <- "Hyperbolic Tangent"}
    } # end compare between two activation function
    
  return (paste("Target variable had been predicted with the", best.act, 
                "activation function, MSE of", best.MSE, "and the correlation of", best.cor))
  }
}