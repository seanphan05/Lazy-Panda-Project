# Onehot function:
feature.encode <- function(norm.train, norm.test, ord.col.train, ord.col.test)
{
  
  # arbitrary encode for ordinal features:
  if(ord.var) 
  {
    for(i in 1:length(ord.vec)) 
    {
      ord.col.train[,i] <- as.character(ord.col.train[,i])
      ord.col.test[,i]  <- as.character(ord.col.test[,i])
      ord.val <- 1:length(ord.vec[[i]])
      
      for  (j in 1:length(ord.val)) 
      {
        ord.col.train[ord.col.train==ord.vec[[i]][j]] <- ord.val[j]
        ord.col.test[ord.col.test==ord.vec[[i]][j]] <- ord.val[j] 
      }
      ord.col.train[,i] <- as.factor(ord.col.train[,i])
      ord.col.test[,i]  <- as.factor(ord.col.test[,i])     
    }
  }
  
  # One hot encoding for categorical features:
  library(onehot)
  # one hot encode for train data
train.encoder    <- onehot(norm.train[,-1], stringsAsFactors=FALSE)
encoded.train    <- as.data.frame(predict(train.encoder, norm.train[,-1]))
new.train        <- as.data.frame(cbind(norm.train[1],encoded.train))

  # one hot encode for test data
test.encoder     <- onehot(norm.test[,-1], stringsAsFactors=FALSE)
encoded.test     <- as.data.frame(predict(test.encoder, norm.test[,-1]))
new.test         <- as.data.frame(cbind(norm.test[1],encoded.test))

  if (ord.var) 
  {
    new.train1     <- data.frame(cbind(new.train,ord.col.train))
    new.test1      <- data.frame(cbind(new.test,ord.col.test))
    return(list(new.train1, new.test1))
  }
  else { return(list(new.train, new.test)) }
}