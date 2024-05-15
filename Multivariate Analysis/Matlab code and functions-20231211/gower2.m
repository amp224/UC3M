%
% La funcion S=gower2(X,p1,p2,p3) calcula una matriz de similaridades,
% segun el coeficiente de similaridad de Gower.
%
% Entradas:
%   X   matriz de datos mixtos, cuyas columnas deben estar ordenadas
%           de la forma: continuas, binarias, categoricas,
%   p1  numero de variables continuas,
%   p2  numero de variables binarias,
%   p3  numero de variables categoricas (no binarias),
%
 function S=gower2(X,p1,p2,p3)
 [n,p]=size(X);
% matriz de variables cuantitativas
 X1=X(:,1:p1);
% matriz de variables binarias
 X2=X(:,p1+1:p1+p2);
% matriz de variables categoricas
 X3=X(:,p1+p2+1:p);
%
% calculos para las variables continuas
 rango=max(X1)-min(X1);
 for i=1:n
    c(i,i)=p1;
    for j=1:i-1
       c(i,j)=p1-sum(abs(X1(i,:)-X1(j,:))./rango);
       c(j,i)=c(i,j);
    end
 end
% calculo de las matrices a y d para las variables binarias
 J=ones(size(X2));
 a=X2*X2';
 d=(J-X2)*(J-X2)';
% calculos de la matriz alpha para las variables categoricas
 for i=1:n
    for j=i:n
        alpha(i,j)=sum(X3(i,:)==X3(j,:));
        alpha(j,i)=alpha(i,j);
    end
 end
 % calculo del coeficiente de similaridad de Gower
 S=(c+a+alpha)./(p*ones(n)-d);