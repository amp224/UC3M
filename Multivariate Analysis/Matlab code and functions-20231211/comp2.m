% COMP2
%
% La funcion [T1,Y1,acum1,T2,Y2,acum2]=comp2(X) calcula las componentes 
% principales de una matriz de datos X (n,p).
%
% Devuelve :
%   T1 componentes principales a partir de la matriz S
%   Y1 representación de los datos
%   acum1 porcentajes acumulados
%   T2 componentes principales a partir de la matriz R
%   Y2 representación de los datos
%   acum2 porcentajes acumulados
% 
% Salidas gráficas: Representación en componentes principales (dim. 2), scree-plot
%                   con el criterio de Kaisser y la modificación del criterio de Kaisser.
%
function [T1,Y1,acum1,T2,Y2,acum2]=comp2(X)
[n,p]=size(X);
% Vector de etiquetas para los individuos.
for i=1:n
  lab(i,:)=sprintf('%3g',i);
end
% Matriz de centrado y matriz de datos centrados.
H=eye(n)-ones(n)/n;
X=H*X;
% Cálculo de las matrices de covarianzas y de correlaciones.
S=cov(X,1);
R=corr(X);
%
% Componentes principales a partir de la matriz de covarianzas.
% Ordenación de los valores propios segun la variabilidad
% explicada (de más a menos). D1 es un vector fila.
% Las columnas de T1 son los vectores propios ordenados.
%
[T1,D1]=eigsort(S);
% Corregimos los signos de T1.
if ((sum(sign(T1(:,1))) < 0) & (sum(sign(T1(:,2))) < 0))
  T1=-T1;
end
s=sum(D1(1:p));
for i=1:p
  percent1(i)=(D1(i)/s)*100;
  acum1(i)=sum(percent1(1:i));
end
% ----------------------------------------------------------
% Componentes principales a partir de la matriz de correlaciones.
% Ordenaciín de los valores propios segun la variabilidad
% explicada (de más a menos). D2 es un vector fila.
% Las columnas de T2 son los vectores propios ordenados.
%
[T2,D2]=eigsort(R);
% corregimos los signos de T2
if ((sum(sign(T2(:,1))) < 0) & (sum(sign(T2(:,2))) < 0))
  T2=-T2;
end
for i=1:p
  percent2(i)=(D2(i)/p)*100;
  acum2(i)=sum(percent2(1:i));
end
% ----------------------------------------------------------
% Las columnas de T1 son las componentes principales.
% Representación de los datos.
Y1=X*T1;
figure
subplot(2,2,1); 
plot(Y1(:,1),Y1(:,2),'.b','MarkerSize',15)
grid
xlabel('1a. Componente Principal','FontSize',10)
ylabel('2a. C.P.','FontSize',10)
title(['A.C.P. a partir de S  (',num2str(acum1(2)),'%)'],'FontSize',10)
if n<=100
   for i=1:n
     text(Y1(i,1),Y1(i,2),lab(i,:));
   end
end   
subplot(2,2,2);
plot(D1,'o-b','LineWidth',2)
hold on
plot(mean(D1)*ones(1,p),'-r','LineWidth',2)
plot(0.7*mean(D1)*ones(1,p),'--r','LineWidth',2)
xlabel('valores propios','FontSize',10)
title(['Scree-plot y Criterio de Kaisser (S)'],'FontSize',10)
axis([1 p 0 D1(1)])
% ---------------------------------------------------------
% Las columnas de T2 son las componentes principales
% (hay que estandarizar las variables).
s=diag(sqrt(diag(S)));
% Representación de los datos.
Y2=X*inv(s)*T2;
subplot(2,2,3); 
plot(Y2(:,1),Y2(:,2),'.b','MarkerSize',15)
grid
xlabel('1a  Componente Principal','FontSize',10)
ylabel('2a. C.P.','FontSize',10)
title(['A.C.P. a partir de R  (',num2str(acum2(2)),'%)'],'FontSize',10)
if n<=100
   for i=1:n
     text(Y2(i,1),Y2(i,2),lab(i,:));
   end
end   
subplot(2,2,4);
plot(D2,'o-b','LineWidth',2)
hold on
plot(ones(1,p),'-r','LineWidth',2)
plot(0.7*ones(1,p),'--r','LineWidth',2)
xlabel('valores propios','FontSize',10)
title(['Scree-plot y Criterio de Kaisser (R)'],'FontSize',10)
axis([1 p 0 D2(1)])
end