# created by Chuong Van Nguyen
## Distributed Algorithm
## chuong Nguyen (use X instead of transpose of X)

rm(list = ls())
#install.packages("plot3D")
library("plot3D")

## Start Time
ptm <- proc.time()

## Load the dataset
ir_df <- iris
X <- as.matrix(ir_df[,1:(ncol(ir_df)-1)])

## Define Parameters 
delta_t <- 0.01 ## time-step for dynamics - not physical time
N_iter <- 10000 ## number of iterations
min_cluster_size_frac = 0.10
lamda = 0.001 # the value of lamda determines clusters, be careful to choose lamda.

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
  d=as.matrix(d)
  ## Compute Laplacian Matrix
  L <- d-d
  for (m in 1:ncol(L)) {
    for (n in 1:nrow(L)) {
      L[m,n]=1/(1+d[m,n]^2/lamda)
    }
    
  }
  diag(L) <- 0
  diag(L) <- - rowSums(L) 
  X = X + delta_t*L%*%X
}

Sepal.Length <- X[,1]
Petal.Length <- X[,3]
Sepal.Width <- X[,2]

scatter3D(Sepal.Length, Petal.Length, Sepal.Width, colvar = NULL, col = "blue",
          pch = 19, cex = 0.5)
