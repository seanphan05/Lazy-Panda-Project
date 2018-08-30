# Modeling data with Decision Tree algorithms:
dtree <- function(norm.train, norm.test)
{
  if (class(norm.train$Target)=="factor") # use Decision Tree for classification
  {
    library(gmodels) # confusion matrix use
    library(C50)
    
    dt.classifier <- C5.0(norm.train[-1], norm.train$Target)
    dt.predict    <- predict(dt.classifier, norm.test)
    
    # Confusion Matrix
    ConMax.dt <- CrossTable(norm.test$Target, dt.predict,
                            prop.chisq = FALSE, prop.c = FALSE, prop.r = FALSE,
                            dnn = c('actual', 'predicted'))
    # accuracy
    table.DT    <- table(norm.test$Target, dt.predict)
    dt.accuracy = round(sum(diag(table.DT)/sum(table.DT)),digits=5)
    dt.accuracy
    
    return(paste("Target variable had been classified with the accuracy of", dt.accuracy))
  }
  else # use CART for numeric prediction
  {
    library(rpart)
    m.rpart <- rpart(Target~., data = norm.train)
    p.rpart <- predict(m.rpart, norm.test)
    
    # calculate corralation
    cor.rpart <- cor(p.rpart, norm.test$Target)
    # function to calculate the mean absolute error
    MAE <- function(actual, predicted) { mean(abs(actual - predicted))}
    # mean absolute error between predicted and actual values
    MAE.rpart <- MAE(p.rpart, norm.test$Target)
    
    return(paste("Target variable had been predicted with correlation of", cor.rpart,
                 "and the mean absolute error of", MAE.rpart))
  }
}