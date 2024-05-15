    % KMEDIAS2
%
% La funcion [C,s,IDX]=kmedias2(X,kmax) obtiene un agrupacion de los individuos 
% de la matriz X (n,p) en k conglomerados, segun el algoritmo de k-medias 
%
% Advertencia: Se usa la funcion kmeans de Matlab, que calcula las
% distancias euclideas entre las filas de X.
%
% Devuelve :
%   C : son las coordenadas de los k puntos medios de cada conglomerado
%   s : el valor medio del silhouette-plot
%   IDX : la clase asiganda a cada individuo
% 
% Salidas graficas: Representacion de los k conglomerados y de los
% centroides y representacion del silhouette-plot
%
function [C,s,IDX]=kmedias2(X,kmax)
% Para cada valor de k (k=2,...,kmax) se repite 20 veces el kmeans y 
% nos quedamos con la particion de mayor calidad (mayor silueta media)
rep=20;
s=zeros(rep,kmax);
% ATENCION:
% Por defecto se usa la distancia eucliea dentro de kmeans
% si se desea otra opcion hay que indicarlo en
% kmeans(X,k0,'Distance','option'), donde 'option' puede ser 
% 'sqeuclidean', 'cityblock', 'cosine', 'correlation', 'hamming'
for i=1:rep
for k0=2:kmax
    [IDX,C0]=kmeans(X,k0); % cambiar la distancia si se desea
    s0=silhouette(X,IDX);
    clear IDX C0
    s(i,k0)=mean(s0); % silueta de cada particion
end
end
%---------------------------------------
% seleccion de la particion de mayor calidad (segun la silueta media)
smean=mean(s);
[smax,k]=max(smean); 
clear s
% Repetimos kmeans con el valor de k seleccionado
% cambiar la distancia si se desea (de forma acorde al bucle anterior)
[IDX,C0]=kmeans(X,k); 
%C=C0(:,1:2);
C=C0;
s=silhouette(X,IDX);
s=mean(s);
%-----------------------------------------
% salidas graficas
close all
n=size(X,1);
for i=1:n
  lab(i,:)=sprintf('%3g',i);
end
figure
subplot(1,2,1)
   gscatter(X(:,1),X(:,2),IDX)
   if n<=100
     for i=1:n
     text(X(i,1),X(i,2),lab(i,:));
     end
   end   
   hold on
   plot(C(:,1),C(:,2),'+k','MarkerSize',6,'LineWidth',2)
   title(['Algoritmo k-medias con ' num2str(k) ' grupos'],'FontSize',10)
subplot(1,2,2)
   silhouette(X,IDX)
   title(['Silhouette-plot para ' num2str(k) ' grupos'],'FontSize',10)
end