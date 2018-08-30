regress <- function(train.data1, test.data1)
{
  # Create dummy variables:
  
  if (class(train.data1$Target)=="factor") # use Logistic Regression for classification
  {
    if (length(unique(train.data1$Target))==2) # Logistic Regression with 2 levels Target variable
    {
      ## Fix the Target variable to be 0 or 1
      train.data1$Target <- as.numeric(train.data1$Target)
      train.data1$Target <- train.data1$Target - 1
      test.data1$Target  <- as.numeric(test.data1$Target)
      test.data1$Target  <- test.data1$Target - 1
      
      # fit the logistic regression model, with all predictor variables
      glm.model <- glm(Target ~.,family=binomial(link='logit'),data=train.data1)
      ano <- anova(glm.model, test="Chisq")
      
      # pick up only significant independent variables:
      rn <- rownames(ano[which(ano[5]<=0.005),])
      f  <- as.formula(paste("Target ~", paste(rn, collapse = " + ")))
      
      # regress model with only significant predictors, alpha = 0.005
      glm.model <- glm(f, family=binomial(link='logit'), data=train.data1)
      anova(glm.model, test="Chisq")
      
      # check Accuracy
      fitted.results   <- predict(glm.model, newdata=test.data1, type='response')
      fitted.results   <- ifelse(fitted.results > 0.5,1,0)
      misClasificError <- mean(fitted.results != test.data1$Target)
      
      return(paste('Target variable has been classified by Logistic Regression method with the accuracy of', 1-misClasificError))
      
    }
    
    else # Multinomial Regression with >2 levels Target variable:
    {
      library(nnet)
      multi.model <- multinom(Target ~ ., data=train.data1) # multinomial model
      pred.model  <- predict(multi.model, test.data1)
      
      # Confusion matrix and Misclassification Error:
      table.multi    <- table(pred.model, test.data1$Target)
      multi.accuracy =  round(sum(diag(table.multi)/sum(table.multi)),digits=5)
      multi.miss     <- mean(as.character(pred.model) != as.character(test.data1$Target))
      
      return(paste('Target variable has been classified by Multinomial method with the accuracy of', 1-misClasificError))
    }
  }
  
  else  # Use Linear Regression for numeric prediction
  { 
    # train the model:
    lm_model <- lm(Target~., data = train.data1)
    lm_pred <- predict(lm_model, test.data1)
    
    # compare the correlation
    lm.cor <- cor(ins_pred, test.data1$Target)
    
    return(paste('Target variable has been predicted with the correlation of', lm.cor))
  }
}