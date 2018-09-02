# Lazy Panda function:
cleanup <- function(train.data, test.data, tar.loc.train, tar.loc.test)
{ ########## start cleanup function
  # Model training type define:
  {
  if (classify) {  # for classification: 
    train.data[tar.loc.train] <- lapply(train.data[tar.loc.train], as.factor)
    test.data[tar.loc.test]   <- lapply(test.data[tar.loc.test], as.factor) }
  else { # for numeric prediciton:
    train.data[tar.loc.train] <- lapply(train.data[tar.loc.train], as.numeric)
    test.data[tar.loc.test]   <- lapply(test.data[tar.loc.test], as.numeric) }
  }
  
  # Imputate missing values:
  imputated.data <- miss.imputate(train.data, test.data)
  train.data     <- as.data.frame(imputated.data[1])
  test.data      <- as.data.frame(imputated.data[2])
  
  # Exclude ordinal variable column(s):
  { # start exclude ordinal variable column(s)
    if (ord.var == TRUE) {
    ord.col.train           <- data.frame(train.data[,ord.loc.train])
    colnames(ord.col.train) <- names(train.data[ord.loc.train])
    target.name.train       <- names(train.data[tar.loc.train])
    train.data1             <- train.data[,-ord.loc.train]
    tar.loc.train1          <- which(colnames(train.data1)==target.name.train)
    
    ord.col.test            <- data.frame(test.data[,ord.loc.test])
    colnames(ord.col.test)  <- names(test.data[ord.loc.test])
    target.name.test        <- names(test.data[tar.loc.test])
    test.data1              <- test.data[,-ord.loc.test] 
    tar.loc.test1           <- which(colnames(test.data1)==target.name.test) }
    
  else { 
    train.data1     <- train.data
    tar.loc.train1  <- tar.loc.train
    test.data1      <- test.data 
    tar.loc.test1   <- tar.loc.test} 
  } # end exclude ordinal variable column(s)
  
  # Rearrange dataset:
      # Rearrange dataset for Regression:
    ordered.data.r  <- rearrange(train.data, test.data, tar.loc.train, tar.loc.test)
    train.data.r   <- as.data.frame(ordered.data.r[1])
    test.data.r    <- as.data.frame(ordered.data.r[2])

      # Rearrange dataset for other methods:
    ordered.data  <- rearrange(train.data1, test.data1, tar.loc.train1, tar.loc.test1)
    train.data1   <- as.data.frame(ordered.data[1])
    test.data1    <- as.data.frame(ordered.data[2])
    other.name.train <- ordered.data[3][[1]]
    other.name.test  <- ordered.data[4][[1]]
    
  # Normalization data
  norm.data <- normf(train.data1, test.data1, other.name.train, other.name.test)
  norm.train <- as.data.frame(norm.data[1])
  norm.test  <- as.data.frame(norm.data[2])
  
  
  # Encode non-numreic features in dataset:
    # for Naive Bayes and Regression training
  encoded.data.nb <- feature.encode(train.data1, test.data1, ord.col.train, ord.col.test)
  norm.train.nb   <- as.data.frame(encoded.data.nb[1])
  norm.test.nb    <- as.data.frame(encoded.data.nb[2])
  
    # for SVM and ANN algorithms training
  encoded.data <- feature.encode(norm.train, norm.test, ord.col.train, ord.col.test)
  new.train    <- as.data.frame(encoded.data[1])
  new.test     <- as.data.frame(encoded.data[2])

  raw1 <- list("train.data"=train.data.r, "test.data"=test.data.r)   # for regression models
  raw2 <- list("train.data"=norm.train, "test.data"=norm.test)       # for models with tree base
  raw3 <- list("train.data"=norm.train.nb, "test.data"=norm.test.nb) # for Naive Bayes
  raw4 <- list("train.data"=new.train, "test.data"=new.test)         # for SVM and ANN algorithms
  
  return(list("Regress"=raw1, "Tree"=raw2, "Naive.Bayes"=raw3, "SVM.&.ANN"=raw4))

} ########## end cleanup function