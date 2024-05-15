% KULC
%
% Dada una matriz de datos binarios X (n,p), la funcion S=rissel(X) devuelve
% la matriz de similaridades, segun el coeficiente de similaridad de Kulcynsky,
% entre los n individuos.
%
%
 function S=kulc(X)
 [n,p]=size(X);
 J=ones(n,p);
 a=X*X';
 b=(J-X)*X';
 c=b';
 % 
 [i0,j0]=find(a+b==0);
 for i=1:length(i0)
     b(i0(i),j0(i))=1;
 end
 clear i0 j0
 [i0,j0]=find(a+c==0);
 for i=1:length(i0)
     c(i0(i),j0(i))=1;
 end 
 S=1/2*(a./(a+b)+a./(a+c));
 clear J a b c
