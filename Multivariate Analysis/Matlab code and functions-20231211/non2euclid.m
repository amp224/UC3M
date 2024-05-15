% non2euclid
%
% Dada una matriz D (nxn) de cuadrados de distancias
% no euclidea, la funcion D1=non2euclid(D) devuelve
% una matriz D1 de cuadrados de distancias euclidea.
%
 function D1=non2euclid(D)
 [n,n]=size(D);
 H=eye(n)-ones(n)/n;
 [T,Lambda]=eig(-H*D*H/2);
 m=min(diag(Lambda));
 D1=D-2*m*ones(n)+2*m*eye(n);