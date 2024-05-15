% COINCIDENCIAS2
%
% Dada una matriz de datos categoricos X (n,p), la funcion 
% S=coincidencias2(X) calcula la matriz de similaridades, segun el coeficiente 
% de similaridad s(i,j)=alpha/(p-alpha).
%
function S=coincidencias2(X)
[n,p]=size(X);
for i=1:n
    alpha(i,i)=p;
    for j=i+1:n
        alpha(i,j)=sum(X(i,:)==X(j,:));
        alpha(j,i)=alpha(i,j);
    end
end
S=alpha./(p*ones(n)-alpha);