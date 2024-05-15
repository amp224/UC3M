% COINCIDENCIAS4
%
% Dada una matriz de datos categoricos X (n,p), la funcion 
% S=coincidencias4(X) calcula la matriz de similaridades, segun el coeficiente 
% de similaridad s(i,j)=alpha/(alpha+2*(p-alpha)).
%
function S=coincidencias4(X)
[n,p]=size(X);
for i=1:n
    alpha(i,i)=p;
    for j=i+1:n
        alpha(i,j)=sum(X(i,:)==X(j,:));
        alpha(j,i)=alpha(i,j);
    end
end
S=alpha./(alpha+2*(p*ones(n)-alpha));