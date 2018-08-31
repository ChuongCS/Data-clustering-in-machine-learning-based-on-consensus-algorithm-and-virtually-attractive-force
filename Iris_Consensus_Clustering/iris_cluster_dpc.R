## Distributed Algorithm
## chuong Nguyen (use X instead of transpose of X)

rm(list = ls())

## Start Time
ptm <- proc.time()

## Load the dataset
ir_df <- iris
#X <- t(as.matrix(ir_df[,1:(ncol(ir_df)-1)]))
X <- as.matrix(ir_df[,1:(ncol(ir_df)-1)])

## Define Parameters 
delta_t <- 0.01 ## time-step for dynamics - not physical time
N_iter <- 1000 ## number of iterations
min_cluster_size_frac = 0.10


## Auto parameter tuning of the sigma and epsilon of the algorithm
#d <- dist(t(X), method='euclidean',diag=TRUE,upper = TRUE)
d <- dist(X, method='euclidean',diag=TRUE,upper = TRUE)
sigma_d = (1/ncol(X))*(sd(d))
epsilon_d = (1/ncol(X))*(sd(d))

## Define the time-stamps for the evolution of dynamics
T=seq(from=0,to=delta_t*N_iter,by=delta_t)

## Evolution of the particles
for(t in 1:length(T)){
  d <- dist(X, method='euclidean',diag=TRUE,upper = TRUE) # Computing Distance matrix from the data
  ## Compute Laplacian Matrix
  Lij <- exp(- as.matrix(d)^2/(sigma_d^2)) # 
  diag(Lij) <- 0
  diag(Lij) <- - rowSums(Lij) 
  ## Update of the position 
  # for(i in 1:ncol(X)){
  #   X[,i]=X[,i] + delta_t*Lij[i,]%*%t(X)
  # }
  X = X + delta_t*Lij%*%X
}
## Update the distances of the particles
final_distance = as.matrix(dist(X, method='euclidean',diag=TRUE,upper = TRUE))
diag(final_distance ) <- 0

## Compute the clusters based on final distance
Cluster = rep(1,nrow(X))
for (i in 2:nrow(X)){
  max_clus = max(Cluster[1:(i-1)])
  flag = 0
  
  for(j in 1:max_clus){
    ind = which(Cluster==j)
    ind = ind[which(ind<i)]
    if(max(final_distance[i,ind])<=epsilon_d){
      Cluster[i] = j
      flag = 1
      break()
    }
  }

  if (flag==0){
    Cluster[i]=max_clus+1
    }
}
## Estimated clusters by the algorithm
estimated_cluster = paste('DPC',Cluster,sep="_")

## Remove small clusters
cluster_stats = table(estimated_cluster)
cluster_stats = as.data.frame(cluster_stats)
small_clusters=as.character(cluster_stats$estimated_cluster[which(cluster_stats$Freq < 
                                        min_cluster_size_frac*nrow(X))])
big_clusters = setdiff(cluster_stats$estimated_cluster, small_clusters)

if(length(small_clusters)>0){
  for(i in 1: length(small_clusters)){
    ind = which(estimated_cluster==small_clusters[i])
    for(j in 1:length(ind)){
      index = ind[j]
      cluster_dist = rep(0,length(big_clusters))
      for (k in 1:length(big_clusters)){
        ind_2 = which(estimated_cluster==big_clusters[k])
        cluster_dist[k] = mean(final_distance[index,ind_2])
      }
      min_ind = which(cluster_dist==min(cluster_dist))
      if(length(min_ind)>1){min_ind=min_ind[1]}
      estimated_cluster[index] = big_clusters[min_ind]
      }
  }
}

## Compute the confusion matrices
actual_cluster = ir_df$Species
confusion_matrix = table(actual_cluster, estimated_cluster)

## Sort confusion matrix to make diagonal heavy
row.max <- apply(confusion_matrix,1,which.max)
confusion_matrix = confusion_matrix[names(sort(row.max)),]

## Compute error which is the sum of off-diagonal of conf matrix
error = sum(confusion_matrix)-sum(diag(confusion_matrix))

confusion_matrix
error

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
