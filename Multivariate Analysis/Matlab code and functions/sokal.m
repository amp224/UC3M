% SOKAL
%
% Dada una matriz de datos binarios X (n,p), la funcion S=sokal(X) devuelve
% la matriz de similaridades, segun el coeficiente de similaridad de Sokal y Michener,
% entre los n individuos.
%
%
 function S=sokal(X)
 [n,p]=size(X);
 J=ones(n,p);
 a=X*X';
 d=(J-X)*(J-X)';
 S=(a+d)/p;