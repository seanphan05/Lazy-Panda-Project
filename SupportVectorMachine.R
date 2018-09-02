# Modeling data with Support Vector Machine (SVM) algorithms:
 suvema <- function(norm.train, norm.test)
 {
   library(gmodels) # confusion matrix use
   library(e1071)
   if (class(norm.train$Target)=="factor") # use SVM for classification
   { 
     svm.classifier <- svm(Target~., data=norm.train)
     # generate predictions for the testing dataset
     svm.predict <- predict(svm.classifier, norm.test)
    
     # cross tabulation of predicted versus actual classes
     CrossTable(norm.test$Target, svm.predict,
                prop.chisq = FALSE, prop.c = FALSE, prop.r = FALSE,
                dnn = c('actual', 'predicted'))
     
     # accuracy
     table.svm <- table(norm.test$Target, svm.predict)
     svm.accuracy = round(sum(diag(table.svm)/sum(table.svm)),digits=5)
     svm.accuracy
     
     return(paste("Target variable had been classified with the accuracy of", svm.accuracy))
   }
   else # use SVM for numeric prediction
   { 
     # linear kernal:
     svm.linear  <- tune.svm(Target~., data=norm.train,
                             kernel="linear", cost = c(.001,.01,.1,1,5,10))
     best.linear <- svm.linear$best.model
     pred.linear <- predict(best.linear, newdata=norm.test)
     linear.res  <- pred.linear-norm.test$Target
     MSE.linear  <- mean(linear.res^2)
     
     # polynormial kernal:
     svm.poly    <- tune.svm(Target~., data = norm.train,
                             kernal="polynomial", degree = c(3,4,5), coef0 = c(.1,.5,1,2,3,4))
     best.poly   <- svm.poly$best.model
     pred.poly   <- predict(best.poly, newdata=norm.test)
     poly.res    <- pred.poly-norm.test$Target
     MSE.poly    <- mean(poly.res^2)
     
     # radial kernel:
     svm.rad     <- tune.svm(Target~., data = norm.train,
                             kernal="radial", gamma = c(.1,.5,1,2,3,4))
     best.rad    <- svm.rad$best.model
     pred.rad    <- predict(best.rad, newdata=norm.test)
     rad.res     <- pred.rad-norm.test$Target
     MSE.rad     <- mean(rad.res^2)
     
     # sigmoid kernel:
     svm.sig     <- tune.svm(Target~., data = norm.train,
                             kernal="sigmoid", gamma = c(.1,.5,1,2,3,4), coef0 = c(.1,.5,1,2,3,4))
     best.sig    <- svm.sig$best.model
     pred.sig    <- predict(best.sig, newdata=norm.test)
     sig.res     <- pred.sig-norm.test$Target
     MSE.sig     <- mean(sig.res^2)
     
     # kernal comparison
     svm.kernal  <- c("Linear", "Polynormial", "Radial", "Sigmoid") 
     svm.MSE     <- c(MSE.linear, MSE.poly, MSE.rad, MSE.sig)
     svm.pred    <- data.frame(pred.linear, pred.poly, pred.rad, pred.sig)
     com.kernal  <- data.frame(svm.kernal, svm.MSE)
     
     mean.MSE    <- min(com.kernal[,2])
     loc.kernal  <- which(com.kernal[2,]==mean.MSE)
     best.kernal <- com.kernal[loc.kernal,1]
     best.pred   <- svm.pred[,loc.kernal]
     
     # calculate corralation
     cor.result  <- round(cor(norm.test$Target, best.pred),digits=5)
     
     return(paste("Target variable had been predicted by", best.kernal, 
                  "kernal with the corralation of", cor.result))
   }
 }