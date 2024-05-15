%
% identif_cualis
%
% La funcion identif_cuantis(X,Y) identifica los grupos en una
% representacion MDS, donde Y son las coordenadas principales (nx2),
% X=[X_1,...,X_k] es la parte de la matriz de datos con las variables 
% cualitativas (nxk).
%
function identif_cualis(X,Y)
[n,k]=size(X);
for j=1:k
   grupo=X(:,j);
%   
   figure
   gplotmatrix(Y(:,1),Y(:,2),grupo,'','+o*.xsd^v><ph',[],'on','') % hasta 10 categorias
%    gplotmatrix(Y(:,1),Y(:,2),grupo,'','',[],'on','') % para mas de 10 categorias
end
