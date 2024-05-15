% COINCIDENCIAS
%
% Dada una matriz de datos categoricos X (n,p), la funcion 
% S=coincidencias(X) calcula la matriz de similaridades, segun el coeficiente 
% de similaridad de coincidencias entre los n individuos.
%
function S=coincidencias(X)
[n,p]=size(X);
S=p*eye(n);
for i=1:n
    for j=i+1:n
        S(i,j)=sum(X(i,:)==X(j,:));
        S(j,i)=S(i,j);
    end
end
S=S/p;