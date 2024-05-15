%
% REGCONF
%
% La funcion r=regconf(mY,n,p,conf) dibuja las regiones
% de confianza para los individuos medios de g poblaciones
% obtenidos a traves de la funcion CANP.
% En cada poblacion se miden p variables sobre n(i) individuos
% (i=1,2,...,g) con n(1)+n(2)+...+n(g)=N.
%
% Entradas:
%   mY = las coordenadas canonicas de los individuos medios,
%   n =  vector columna que contiene el numero de individuos
%        de cada poblacion,
%   p = numero de variables medidas sobre cada poblacion,
%   conf = nivel de confianza (0<=conf<=1) para el que 
%        se construyen las regiones confidenciales
%        (por ejemplo, conf=0.90).
%
% Salidas:
%   r = vector que contiene los radios de las esferas.
%
 function r=regconf(mY,n,p,conf)
 g=length(n);
 N=sum(n);
% valor critico de una F(p,N-g-p+1) para el nivel de
% confianza (conf) especificado.
 F=finv(conf,p,N-g-p+1);
%
% calculo de las regiones de confianza (al conf*100%)
% para los individuos medios. 
%
 for i=1:g
   r(i)=sqrt(F*p*(N-g)/((N-g-p+1)*n(i)));
 end
 for i=0:0.01:2*pi
   theta(floor(i*100+1))=i;
 end
%
% vector de etiquetas para los individuos medios
%
 for i=1:g
   lab(i,:)=sprintf('%3g',i);
 end
%
hold on
 plot(mY(:,1),mY(:,2),'^r','MarkerFaceColor',[1 0 0]) 
 xlabel('1er. eje canonico','FontSize',10)
 ylabel('2o. eje canonico','FontSize',10)
%
 for i=1:g
   for j=1:length(theta)
      cercle(j,1)=mY(i,1)+cos(theta(j))*r(i);
      cercle(j,2)=mY(i,2)+sin(theta(j))*r(i);
   end
   plot(cercle(:,1),cercle(:,2),'.m','MarkerSize',4)
 end
 pconf=conf*100;
 title(['Regiones de confianza para los individuos medios al ',num2str(pconf),'%'],'FontSize',12)
 for i=1:g
   text(mY(i,1),mY(i,2),lab(i,:));
 end
 hold off
 end