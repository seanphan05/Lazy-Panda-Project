# Modeling data with Naive Bayes algorithms:
nb <- function(norm.train, norm.test)
{
  if (class(norm.train$Target)=="factor") # use Naive Bayes for classification
  {
    library(gmodels) # confusion matrix use
    library(e1071)
    #norm.train$Target    <- factor(norm.train$Target)
    #norm.test$Target     <- factor(norm.test$Target)
    nb.classifier <- naiveBayes(norm.train, norm.train$Target)
    nb.predict    <- predict(nb.classifier, norm.test)
    head(nb.predict)
    
    # Confusion Matrix
    ConMax.nb  <- CrossTable(nb.predict, norm.test$Target,
                            prop.chisq = FALSE, prop.t = FALSE, prop.r = FALSE,
                            dnn = c('predicted', 'actual'))
    # accuracy
    table.NB    <- table(norm.test$Target, nb.predict)
    nb.accuracy = round(sum(diag(table.NB)/sum(table.NB)),digits=5)
    nb.accuracy

    return(paste("Target variable had been classified with the accuracy of", nb.accuracy))
  }
  else 
  { return("Could not use Naive Bayes for numerical prediction")}
}