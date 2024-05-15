% COORP
%
% La funcion [Y,vaps,percent,acum] = coorp(D) calcula las coordenadas
% principales a partir de una matriz de D de cuadrados distancias,
%
% Entradas:  D = matriz de cuadrados de distancias.
%
% Devuelve:
%    X = matriz de coordenadas principales,
%    vaps = vector fila que contiene los valores propios,
%    percent = vector fila que contiene los porcentajes de variabilidad
%              explicados por cada coordenada.
%    acum = vector fila que contiene los porcentajes de variabilidad
%              acumulados.
%
 function [Y,vaps,percent,acum] = coorp(D)
 n=size(D,1);
% comprobamos que D es euclidea (ie, B>=0)
 H=eye(n)-ones(n)/n;
 B=-H*D*H/2;
 L=eig(B);
 m=min(L);
 epsilon=1.e-6;
 if abs(m) > epsilon
    % hacemos la transformacion non2euclid
    D1=non2euclid(D);
    B=-H*D1*H/2;
 end
%--------------------------------------------------
% calculo de las coordenadas principales (solo consideramos
% las no nulas)
 [T,Lambda,V]=svd(B);
 vaps=diag(Lambda)';
 nvaps=find(abs(vaps)>epsilon);
 T1=T(:,nvaps);
 Y=T1*sqrt(Lambda(nvaps,nvaps));
 percent=vaps/sum(vaps)*100;
 acum=zeros(1,n);
 for i=1:n
    acum(i)=sum(percent(1:i));
 end
%-----------------------------------------------------
% vector de etiquetas para los individuos
 if n<=100
    for i=1:n
      lab(i,:)=sprintf('%3g',i);
    end
  end
%-----------------------------------------------------
% representacion de los datos en dimension 2
 figure (1)
 plot(Y(:,1),Y(:,2),'.b','MarkerSize',15)
 grid
 xlabel('Primera coordenada principal','FontSize',12)
 ylabel('Segunda coordenada principal','FontSize',12)
 title(['Porcentaje de variabilidad explicada ',num2str(acum(2)),'%'],'FontSize',12)
 if n<=100
    for i=1:n
       text(Y(i,1),Y(i,2),lab(i,:));
    end
 end
%-----------------------------------------------------
% porcentaje de variabilidad explicada
 figure (2)
 plot(acum,'o-b','LineWidth',2)
 xlabel('Valores propios','FontSize',12)
 title(['Porcentaje de variabilidad acumulada'],'FontSize',12)
 xmax=length(find(vaps>1.e-10));
 axis([1 xmax 0 100])
 end
