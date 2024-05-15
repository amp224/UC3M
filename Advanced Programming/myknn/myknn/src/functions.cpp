#include <Rcpp.h>
using namespace Rcpp;

#include <Rcpp.h>
using namespace Rcpp;

// This is a simple example of exporting a C++ function to R. You can
// source this function into an R session using the Rcpp::sourceCpp 
// function (or via the Source button on the editor toolbar). Learn
// more about Rcpp at:
//
//   http://www.rcpp.org/
//   http://adv-r.had.co.nz/Rcpp.html
//   http://gallery.rcpp.org/
//


double euclidean(NumericVector x, NumericVector y) {
  // calculates the distance between x and y from the Euclidean norm 
  double distance = sqrt(sum(pow((x-y),2)));
  return distance;
}

// [[Rcpp::export]]
int my_knn_c_euclidean( NumericMatrix X, NumericVector X0, NumericVector y){
  // Performs kNN (with k=1) classification with Euclidean distance
  //
  // Arguments:
  //  X data matrix with input attributes
  //  y response variable values of instances in X  
  //  X0 vector of input attributes for prediction (just one instance)
  
  
  int nrows=X.nrow();
  double distance=0;
  
  // calculates distance to first point
  distance=euclidean(X(1,_),X0);
  double closest_distance=distance;
  double closest_output = y[1];
  int closest_neighbor=1;
  
  // calculates the distance to each point
  for (int i=1;i<nrows;i++){
    distance=euclidean(X(i,_),X0);
    // if there is a closer neighbor, save its label
    if (distance<closest_distance){
      closest_distance = distance;
      closest_output = y[i];
    }
  }
  // after the loop only the information of closest neighbor remains
  return closest_output;
}


double minkowsky(NumericVector x, NumericVector y, double p){
  // calculates the minkowsky distance between two points for a given p
  double distance;
  if (p > 0){
    distance = pow(sum(pow(x-y,p)),1/p);
  }
  // if p=0, use infinity-norm distance
  else{
    distance = max(abs(x-y));
  }
  return distance;
}


// [[Rcpp::export]]
int my_knn_c_minkowsky( NumericMatrix X, NumericVector X0, NumericVector y, 
                        double p){
  // Performs kNN (with k=1) classification with minkowsky distance
  // for a given p´
  // 
  // X: data matrix with input attributes
  // y: response variable values of instances in X  
  // X0: vector of input attributes for prediction (just one instance)
  // p: parameter for the minkowsky distance
  int nrows=X.nrow();
  double distance=0;
  distance=minkowsky(X(1,_),X0,p);
  
  double closest_distance=distance;
  double closest_output = y[1];
  int closest_neighbor=1;
  
  for (int i=1;i<nrows;i++){
    distance=minkowsky(X(i,_),X0,p);
    if (distance<closest_distance){
      closest_distance = distance;
      closest_output = y[i];
      closest_neighbor = i;
    }
  }
  
  return closest_output;
}

// Some auxiliary functions to divide the dataset into train and test
// with a 2/3-1/3 proportion

NumericMatrix keepFirstTwoThirds(NumericMatrix mat) {
  // Extracts the first two thirds (in terms of rows) of a given matrix
  // Arguments:
  //  mat: a numeric matrix
  
  int numRows = mat.nrow();
  int numRowsToKeep = (2 * numRows) / 3;
  
  // matrix to save the extracted rows
  NumericMatrix result(numRowsToKeep, mat.ncol());
  
  // copies each element individually
  for (int j = 0; j < mat.ncol(); ++j) {
    for (int i = 0; i < numRowsToKeep; ++i) {
      result(i, j) = mat(i, j);
    }
  }
  return result;
}

NumericVector keepFirstTwoThirdsVector(NumericVector vec) {
  // Extracts the first two thirds of a vector
  // Arguments:
  // vec: a numeric vector
  
  int vecSize = vec.size();
  int elToKeep = (2 * vecSize) / 3;
  
  // vector to save to extracted elements
  NumericVector result(elToKeep);
  
  // copies each element individually
  for (int j = 0; j < elToKeep; ++j) {
    result(j) = vec(j);
  }
  return result;
}


NumericMatrix keepLastOneThird(NumericMatrix mat) {
  // Extracts the last one third (in terms of rows) of a matrix
  // Argument:
  //  mat: a numeric matrix
  int numRows = mat.nrow();
  int numRowsToKeep = numRows / 3;
  
  // matrix to save the extracted rows
  NumericMatrix result(numRowsToKeep, mat.ncol());
  
  // copies each element individually
  for (int i = 0; i < numRowsToKeep; ++i) {
    for (int j = 0; j < mat.ncol(); ++j) {
      result(i, j) = mat(numRows - numRowsToKeep + i, j);
    }
  }
  
  return result;
}


NumericVector keepLastOneThirdVector(NumericVector vec) {
  // Extracts the last one third of a vector
  // Argument:
  // vec: a numeric vector
  int vecSize = vec.size();
  int elToKeep = vecSize / 3;
  
  // vector to save the extracted elements
  NumericVector result(elToKeep);
  
  // copies each element individually
  for (int j = 0; j < elToKeep; ++j) {
    result(j) = vec(vecSize - elToKeep + j);
  }
  return result;
}


// [[Rcpp::export]]
int my_knn_tuningp(NumericMatrix X, NumericVector X0, NumericVector y,
                   NumericVector possible_p) {
  // Given a vector of minkowsky parameters, studies the performance of
  // kNN classification for each one and predicts
  // the label using the most optimal parameter
  // 
  // Arguments:
  //  X: data matrix with input attributes
  //  y: response variable values of instances in X  
  //  X0: vector of input attributes for prediction (just one instance)
  // 
  int ncol=X.ncol();
  // to keep track of the accuracy and the best p
  int rights;
  double best = 0;
  double best_p = 0;
  
  // split the data in train-test
  // Train data
  NumericMatrix X_train = keepFirstTwoThirds(X);
  NumericVector y_train = keepFirstTwoThirdsVector(y);
  // Test data
  NumericMatrix X_test = keepLastOneThird(X);
  NumericVector y_test = keepLastOneThirdVector(y);
  
  for (int i=0;i<possible_p.size();i++){
    // reset the right-guess counter
    rights = 0;
    
    // predict with minkowsky kNN the label for each element in the test set
    for (int j=0; j<X_test.nrow();j++){
      int out = my_knn_c_minkowsky(X_train, X_test(j,_), y_test(j),
                                   possible_p(i));
      // register if the prediction is right
      if (out == y_test(j)){
        rights++;
      }
    }
    
    // the accuracy is the number of right guesses over the number of
    // observations in the test set
    double acc = rights/X_test.nrow();
    
    if (acc > best){
      // save the p that gives the best model
      best_p = possible_p(i);
    }
  }
  // Show the best value of p among the ones given
  Rcout << "The best value for p is:" << best_p << "\n";
  
  // return the predicted label
  return my_knn_c_minkowsky(X, X0, y, best_p);
}
