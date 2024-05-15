%
% La funcion corr_table=correlaciones2(X,Y,pcuant,pnominal) calcula las correlaciones/asociaciones 
% entre las variables originales (columnas de X) y los dos primeros ejes principales de 
% la representacion MDS (tres primeras columnas de Y).
% También devuelve una figura gráfica con las correlaciones/asociaciones.
%
% Para las variables cuantitativas se calcula la correlacion de Pearson,
% para las binarias la V de Cramer y para el resto la correlacion de
% Spearman.
%
% Entradas X matriz de datos originales (las columnas deben estar ordenadas como 
%              cuantitativas, nominales, ordinales) 
%          Y matriz de coordenadas principales (tres primeras coordenadas principales)
%          pcuant numero de variables cuantitativas de X
%          pnominal numero de variables nominales
%
function corr_table=correlaciones2(X,Y,pcuant,pnominal)
p=size(X,2); pordinal=p-pcuant-pnominal;
corr_table=zeros(p,3);
% correlaciones con las pcuant variables cuantitativas
corr_table(1:pcuant,:)=corr(Y(:,1:3),X(:,1:pcuant),'type','Pearson')';
% asociaciones con las pnominal variables binarias
for i=pcuant+1:pcuant+pnominal 
    corr_table(i,:)=[CramerV(X(:,i),Y(:,1)) CramerV(X(:,i),Y(:,2)) CramerV(X(:,i),Y(:,3))];
end
% correlaciones con las pordinal variables cualitativas (no binarias)
corr_table(pcuant+pnominal+1:p,:)=corr(Y(:,1:3),X(:,pcuant+pnominal+1:p),'type','Spearman')';

% para dibujar el mapa de calor (heatmap)
L1={'PC1','PC2','PC3'};
%L2=colN;
%L2=[colN,'MAX','MIN'];
MM=corr_table;
dd=size(MM);
figure
mymap=[0 0 0.8
0 0.4 1
0.4 0.8 1
1 1 1
1 0.6 1
1 0.2 0.8
0.5 0 0.5];
colormap(mymap);
% colormap('jet'); % set the colorscheme
clims=[-1 1];
imagesc(MM,clims); % plot the matrix
set(gca, 'XTick', 1:dd(2)); % center x-axis ticks on bins
set(gca, 'YTick', 1:dd(1)); % center y-axis ticks on bins
set(gca, 'XTickLabel', L1); % set x-axis labels
%set(gca, 'YTickLabel', L2); % set y-axis labels
title('Principlal Coordirnates Heatmap', 'FontSize', 12); % set title
colorbar; % enable colorbar
end
