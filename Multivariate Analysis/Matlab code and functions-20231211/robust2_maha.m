   %
   % La funcion D=robust2_maha(X) calcula una matriz de cuadrados de
   % distancias. El elemento (i,j) de la matriz D contiene el
   % cuadrado de una version robusta de la distancia de Mahalanobis 
   % entre la fila "i" y la fila "j" de la matriz X.
   %
   % Entradas: una matriz X de dimension nxp.
   % Salidas: una matriz D de dimension nxn.
   %
   function D=robust2_maha(X)
   [n,p]=size(X);
   % calculo del vector de medias y de la matriz de covarianzas
   % de X:
   m=trimmean(X,20); 
   S=(X-ones(n,1)*m)'*(X-ones(n,1)*m)/n;
   % calculo de las distancias de Mahalanobis (al cuadrado):
   D=zeros(n);
   invS=inv(S);
   for i=1:n
      for j=i+1:n
         D(i,j)=(X(i,:)-X(j,:))*invS*(X(i,:)-X(j,:))';
      end
   end
   D=D+D';