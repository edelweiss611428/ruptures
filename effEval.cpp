#include <RcppArmadillo.h>
using namespace Rcpp;

// [[Rcpp::depends(RcppArmadillo)]]

// [[Rcpp::export]]
arma::mat Cpp_getCumsum(const arma::mat& X) {
  
  int nr = X.n_rows;
  int nc = X.n_cols;
  
  arma::mat CumsumMat(nr+1, nc, arma::fill::zeros);
  
  for(int i=0; i<nr; i++) {
    
    CumsumMat.row(i+1) = CumsumMat.row(i) + X.row(i); 
    //use output from previous iteration for efficiency
    
  }
  
  return CumsumMat;
  
} 



class Cost {
private:
  arma::mat X; 
  arma::mat CSX; //cumsum(X)
  arma::mat CSXsq; //cumsum(Xsq)
  
public:
  
  Cost(const arma::mat& inputMat) { //initialise a Cost object
    X = inputMat;
    CSX = Cpp_getCumsum(inputMat);
    CSXsq = Cpp_getCumsum(arma::pow(inputMat, 2));
  }
  
  
  double Cpp_Eval(int start, int end) const {  //no precomputation
    
    int nc = X.n_cols;
    int ncr = end - start;
    arma::rowvec sumX =  arma::zeros<arma::rowvec>(nc);
    
    for(int i=start; i<end; i++) {
      sumX = sumX + X.row(i);  
    }
    
    arma::rowvec meanX = sumX/ncr;
    
    double error = 0;
    double eucldist;
    for(int i=start; i<end; i++) {
      eucldist = arma::norm(X.row(i) - meanX, 2);
      error = error + std::pow(eucldist, 2);
    }
    
    return error;
  }
  
   
  double Cpp_effEval(int start, int end) const {  //use precomputation
    
    int ncr = end - start;
    double errsumXsq =  arma::sum(CSXsq.row(end) - CSXsq.row(start));
    double sqerrsumX =  std::pow(arma::norm(CSX.row(end) - CSX.row(start),2), 2);
    
    return errsumXsq - sqerrsumX/ncr;
    
  }
  
};

RCPP_MODULE(mod_Cost) {  //to use the class Cost in R
  class_<Cost>( "Cost")
  .constructor<arma::mat>()
  .method( "Cpp_Eval", &Cost::Cpp_Eval)
  .method( "Cpp_effEval", &Cost::Cpp_effEval)
  ;
}



