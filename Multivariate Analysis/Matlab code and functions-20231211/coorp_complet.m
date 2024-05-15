%
% Esta funcion se utiliza dentro del programa sensitividad_Gower.m que realiza un analisis 
% de sensitividad de la representacion MDS obtenida a partir de la distancia de Gower. 
%
% La funcion [Ycomplet,percentacum]=coorp_complet(D) devuelve las dos primeras coordenadas 
% principales del conjunto de datos Xdat.

function [Ycomplet,percentacum]=coorp_complet(D)
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
% calculo de las coordenadas principales (solo consideramos las tres primeras)
 [T,Lambda,V]=svd(B);
 T1=real(T(:,1:3));
 % control de signos de las coordenadas (siempre el primer valor positivo)
 if T1(1,1)>0
     T1(:,1)=-T1(:,1);
 end
 if T1(1,2)>0
     T1(:,2)=-T1(:,2);
 end     
 if T1(1,3)>0
     T1(:,3)=-T1(:,3);
 end  
 Ycomplet=T1*sqrt(Lambda(1:3,1:3));
 percentacum=(Lambda(1,1)+Lambda(2,2))/sum(diag(Lambda))*100; %en la representacion en dim 2
 clear H B
%-----------------------------------------------------