# Rearrange function:
rearrange <- function (train.data, test.data, tar.loc.train, tar.loc.test) 
  {
  # train data
  tar.name.train     <- names(train.data[tar.loc.train])
  class.train        <- lapply(train.data[-tar.loc.train], class)
{ # start rearrange train data
  if (any(class.train=="factor")) {
    char.name.train  <- names(which(class.train=="factor"))
    char.loc.train   <- match(char.name.train, names(train.data))
    other.name.train <- names(train.data[-c(char.loc.train, tar.loc.train)])
    col.order.train  <- c(tar.name.train, other.name.train, char.name.train)
    train.data1      <- train.data[,col.order.train] }
  else {
    other.name.train <- names(train.data[-tar.loc.train])
    col.order.train  <- c(tar.name.train, other.name.train)
    train.data1      <- train.data[,col.order.train] }
} # end rearrange train data
  names(train.data1)[1] <- paste("Target")

  # test data
  tar.name.test      <- names(test.data[tar.loc.test])
  class.test         <- lapply(test.data[-tar.loc.test], class)
{ # start rearrange test data
  if (any(class.test=="factor")) {
    char.name.test   <- names(which(class.test=="factor"))
    char.loc.test    <- match(char.name.test, names(test.data))
    other.name.test  <- names(test.data[-c(char.loc.test, tar.loc.test)])
    col.order.test   <- c(tar.name.test, other.name.test, char.name.test)
    test.data1       <- test.data[,col.order.test] } 
  else {
    other.name.test  <- names(test.data[-tar.loc.test])
    col.order.test   <- c(tar.name.test, other.name.test)
    test.data1       <- test.data[,col.order.test] }
} # end rearrange test data
  names(test.data1)[1]  <- paste("Target")
  
  return(list(train.data1, test.data1, other.name.train, other.name.test))
  }