## Mean-shift

rm(list = ls())
library('MeanShift')

## Start Time
ptm <- proc.time()

iter = 1
ir_df <- iris

X <- t(as.matrix(ir_df[,1:(ncol(ir_df)-1)]))

## Error Vector
error_vec = rep(0,iter)

for(i in 1:iter){
  sol <- bmsClustering(X)
  
  estimated_cluster = paste('MEANSHIFT',sol$labels,sep="_")
 
  actual_cluster = ir_df$Species
  
  confusion_matrix = table( actual_cluster, estimated_cluster)
  
  ## Sort Confusion Matrix to make it diagonal heavy 
  ## As not all the clusters are assigned by name
  
  row.max <- apply(confusion_matrix,1,which.max)
  confusion_matrix = confusion_matrix[names(sort(row.max)),]
  
  error = sum(confusion_matrix)-sum(diag(confusion_matrix))
  error_vec[i] = error
  
  if(i==1){
    confusion_matrix_best= confusion_matrix
    error_min = error
  } else if (error_min > error){
    confusion_matrix_best= confusion_matrix
    error_min = error
  }
  
}

confusion_matrix_best
min(error_vec)
mean(error_vec)
sd(error_vec)

f_score=rep(0,nrow(confusion_matrix))
for (k in 1:nrow(confusion_matrix)){
  if(k<=ncol(confusion_matrix)){
    precision = confusion_matrix[k,k]/sum(confusion_matrix[k,])
    recall = confusion_matrix[k,k]/sum(confusion_matrix)
    if(precision+recall>0){
      f_score[k] = 2*(precision*recall)/(precision+recall)
    } else {
      f_score[k] = 0
    }
  }
}
 mean(f_score)

## End time
proc.time() - ptm