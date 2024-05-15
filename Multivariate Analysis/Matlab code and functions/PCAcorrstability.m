% fucntion PCAcorrstability
% this function performs a stability study on PCA's by leave-one-out 
% PCA is computed by means of the sample correlation matrix
%
function rowsummary=PCAcorrstability(X)
Z=zscore(X);
rowsummary=PCAcovstability(Z);
end