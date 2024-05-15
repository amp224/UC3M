###############################################################################
# Code for KNN starts here. You have to translate this code into C++ / Rcpp

my_knn_R = function(X, X0, y){
  # X data matrix with input attributes
  # y response variable values of instances in X  
  # X0 vector of input attributes for prediction (just one instance)
  
  nrows = nrow(X)
  ncols = ncol(X)
  
  distance = 0
  for(j in 1:ncols){
    difference = X[1,j]-X0[j]
    distance = distance + difference * difference
  }
  
  distance = sqrt(distance)

  closest_distance = distance
  closest_output = y[1]
  closest_neighbor = 1
  
  for(i in 2:nrows){
    
    distance = 0
    for(j in 1:ncols){
      difference = X[i,j]-X0[j]
      distance = distance + difference * difference
    }
    
    distance = sqrt(distance)
    
    if(distance < closest_distance){
      closest_distance = distance
      closest_output = y[i]
      closest_neighbor = i
    }
  }
  closest_output
}  

# Code for KNN ends here. 
##############################################################################



## Here, we test the function we just programmed ###

# X contains the inputs as a matrix of real numbers
data("iris")

set.seed(123)

iris_shuffled <- iris[sample(nrow(X)),]

# X contains the input attributes (excluding the class)
X <- iris[,-5]
# y contains the response variable (named medv, a numeric value)
y <- iris[,5]


# From dataframe to matrix
X <- as.matrix(X)
# From factor to integer
y <- as.integer(y)

# This is the point we want to predict

X0 <- c(5.80, 3.00, 4.35, 1.30)

# Using my_knn and class:knn to predict point X0

print(my_knn_R(X, X0, y))

library(class)
print(class::knn(X, X0, y, k=1))


library(Rcpp)

sourceCpp('a.cpp')

my_knn_tuningp(X, X0, y, seq(0,1,by=0.02))
