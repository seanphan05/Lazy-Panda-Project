# normalization function:

normf <- function(train.data1, test.data1, other.name.train, other.name.test) {
# detect character columns:
normalize <- function(x) {return((x - min(x)) / (max(x) - min(x)))}

{ # start normalize train data
if (class(train.data1[,1])!="factor") 
  { new.train1  <- as.data.frame(lapply(train.data1[,1:(length(other.name.train)+1)], normalize))
    new.train2  <- as.data.frame(train.data1[-(1:(length(other.name.train)+1))])
    norm.train  <- as.data.frame(c(new.train1,new.train2))  }
else 
  { new.train1  <- as.data.frame(lapply(train.data1[,2:(length(other.name.train)+1)], normalize))
    new.train2  <- as.data.frame(train.data1[-(1:(length(other.name.train)+1))])
    norm.train  <- as.data.frame(c(train.data1[1],new.train1,new.train2))  }
} # end normalize train data

{ # start normalize test data
if (class(test.data1[,1])!="factor") 
{ new.test1  <- as.data.frame(lapply(test.data1[,1:(length(other.name.test)+1)], normalize))
  new.test2  <- as.data.frame(test.data1[-(1:(length(other.name.test)+1))])
  norm.test  <- as.data.frame(c(new.test1,new.test2))  }
else 
{ new.test1  <- as.data.frame(lapply(test.data1[,2:(length(other.name.test)+1)], normalize))
  new.test2  <- as.data.frame(test.data1[-(1:(length(other.name.test)+1))])
  norm.test  <- as.data.frame(c(test.data1[1],new.test1,new.test2))  }
} # end normalize test data

return(list(norm.train,norm.test))
}