%
% identif_cuantis
%
% La funcion identif_cuantis(X,Y) identifica los grupos en una
% representacion MDS, donde Y son las coordenadas principales (nx2),
% X=[X_1,...,X_p1] es la parte de la matriz de datos con las variables 
% cuantitativas (nxp1).
% Cada variable X_j se categoriza en funcion de sus cuartiles.
%
function identif_cuantis(X,Y)
[n,p1]=size(X);
for j=1:p1
   g=quantile(X(:,j),[.25 .50 .75]);
   n1=find(X(:,j)<=g(1)); 
   n2=find((X(:,j)>g(1)) & (X(:,j)<=g(2))); 
   n3=find((X(:,j)>g(2)) & (X(:,j)<=g(3))); 
   n4=find((X(:,j)>g(3)));
%   
   grupo=ones(n,1); grupo(n2)=2*grupo(n2);
   grupo(n3)=3*grupo(n3); grupo(n4)=4*grupo(n4);
%   
   figure
   gplotmatrix(Y(:,1),Y(:,2),grupo,'brkg','+o.v',[],'on','')
end
