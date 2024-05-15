# R code
rSim <- function(coeff, errors) {
  simdata <- matrix(0, nrow(errors), ncol(errors))
  for (row in 2:nrow(errors))
    simdata[row,] = coeff %*% simdata[(row-1),] + errors[row,]
  return(simdata)
}

# sample parameter and error terms, and simulation
set.seed(42)
a <- matrix(c(0.5,0.1,0.1,0.5), nrow=2)
e <- matrix(rnorm(10000), ncol=2)
x <- rSim(a, e)


library(RcppArmadillo)
# RcppArmadillo code
Rcpp::cppFunction(
  "
  arma::mat cppSimArma(const arma::mat& coeff, const arma::mat& errors) {
    // size_t in Rcpp instead of int to avoid warnings because of 
    // types not being exactly the same
    // in RcppArmadillo arma::uword instead of size_t
    arma::uword rows = errors.n_rows;
    arma::uword cols = errors.n_cols;
  
    arma::mat simdata = arma::zeros(rows, cols);
    
    for (size_t i=1; i < rows; i++){
      simdata.row(i) = (coeff * simdata.row(i-1).t()).t() + errors.row(i);
    }
    return simdata;
  }
  ", 
  depends='RcppArmadillo'
)

y = cppSimArma(a,e)


library(microbenchmark)

microbenchmark::microbenchmark(rSim(a,e), cppSimArma(a,e))


# 

Rgibbs <- function(N, thin) {
  mat <- matrix(0,ncol=2,nrow=N)
  x <- 0
  y <- 0
  for (i in 1:N) {
    for (j in 1:thin) {
      x <- rgamma(1,3,y*y+4)
      y <- rnorm(1,1/(x+1),1/sqrt(2*(x+1)))
    }
    mat[i,] <- c(x,y)
  }
  mat
}

# sample parameters and simulation
n <- 2000
thn <- 200
set.seed(42)
x <- Rgibbs(n, thn)

Rcpp::cppFunction(
  "
  NumericMatrix rGibbsRcpp(int n, int thin){
    NumericMatrix mat = NumericMatrix(n,2);
    double x = 0;
    double y = 0;
    
    for (int i=0; i<n; i++){
      for (int j=0; j<thin; j++){
        x = R::rgamma(3, y * y + 4);
        y = R::rnorm(1/(x + 1), 1/sqrt(2 * (x+1)));
      }
      mat(i,_) = NumericVector::create(x,y);
    }
    return mat;
  }
  "
)

set.seed(42)
y <- rGibbsRcpp(n, thn)
