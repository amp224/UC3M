% SNEATH
%
% Dada una matriz de datos binarios X (n,p), la funcion S=sneath(X) devuelve
% la matriz de similaridades, segun el coeficiente de similaridad de Sneath-Sokal,
% entre los n individuos.
%
%
 function S=sneath(X)
 [n,p]=size(X);
 J=ones(n,p);
 a=X*X';
 b=(J-X)*X';
 c=b';
 S=a./(a+(b+c)/2);
