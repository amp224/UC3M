%
% Esta funcion se utiliza dentro del programa sensitividad_Gower.m que realiza un analisis de 
% sensitividad de la representacion MDS obtenida a partir de la distancia de Gower. 
%
% La funcion [Y,Lambda0]=coorp_minus(D) devuelve las dos primeras coordenadas 
% principales del conjunto de datos Xdat sin el individuo i-esimo.

function [Y,Lambda0]=coorp_minus(D)
%
% comprobamos que D es euclidea (ie, B>=0)
 [n,n]=size(D);
 H = eye(n)-ones(n)/n;
 B = -H*D*H/2;
 L=eig(B);
 m=min(L);
 epsilon=1.e-6;
 if abs(m) < epsilon
    % hacemos la transformacion non2euclid
    D1=non2euclid(D);
    B=-H*D1*H/2;
 end
%--------------------------------------------------
% calculo de las coordenadas principales (solo consideramos las dos primeras)
 [T,Lambda,V]=svd(B);
 T0=real(T(:,1:3));
 % control de signos de las coordenadas (siempre el primer valor positivo)
 if T0(1,1)>0
     T0(:,1)=-T0(:,1);
 end
 if T0(1,2)>0
     T0(:,2)=-T0(:,2);
 end     
 if T0(1,3)>0
     T0(:,3)=-T0(:,3);
 end  
 Lambda0=Lambda(1:3,1:3);
 Y=T0*sqrt(Lambda0);
 %-----------------------------------------------------
