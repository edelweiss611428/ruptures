library("Rcpp")
library("RcppArmadillo")

R_getCumsum = function(X){
  
  nr = nrow(X)
  nc = ncol(X)
  CumsumMat = matrix(nrow = nr+1, ncol = nc, data = 0)
  CumsumMat[2:(nr+1),] = apply(X, 2, cumsum)
  
  return(CumsumMat)
}


R_eval = function(X, start, end){
  R_start = start+1
  R_end = end
  
  Xe = X[R_start:R_end,]
  cMXe = colMeans(Xe)
  
  return(sum(sweep(Xe, 2, cMXe, FUN = "-")^2))
}




