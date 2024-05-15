%
% Dadas dos matrices de cuadrados de distancias D1 y D2 medidas
% sobre el mismo conjunto de n individuos, la funcion relmds2(D1,D2) 
% calcula una metrica conjunta a partir de D1 y D2
% (eliminando la infomacion redundante). Ver Cuadras (1998).
%
function D=relms2(D1,D2)
% Atencion: D1 y D2 deben ser de la misma dimension
[n,n]=size(D1);
H=eye(n)-ones(n)/n;
% estandarizacion de D1 y D2 a variabilidad geometrica 1
vg1=sum(sum(D1))/n^2; vg2=sum(sum(D2))/n^2;  
D1=D1/vg1; D2=D2/vg2; 
% matrices de productos internos para D1 y D2
G1=-1/2*H*D1*H; G2=-1/2*H*D2*H; 
G0=G1+G2;
clear H D1 D2 
% matriz conjunta de productos internos
%G11=real(G1^(1/2)); G22=real(G2^(1/2)); G33=real(G3^(1/2));
[U,L,V]=svd(G1);
G11=real(U*diag(sqrt(diag(L)))*U');
clear U L V G1
[U,L,V]=svd(G2);
G22=real(U*diag(sqrt(diag(L)))*U');
clear U L V G2
G=G0-(G11*G22+G22*G11)/2;
clear G11 G22
Gperfil=diag(G)*ones(1,n);
% matriz conjunta de cuadrados de distancias
D=Gperfil+Gperfil'-2*G;