   %
   % La funcion D=robustG_maha(X) calcula una matriz de cuadrados de
   % distancias. El elemento (i,j) de la matriz D contiene el
   % cuadrado de una version robusta de la distancia de Mahalanobis 
   % entre la fila "i" y la fila "j" de la matriz X.
   % Ver la paginas 149-150 del libro "Methods for statistical data analysis 
   % of multivariate observations" de Gnanadesikan (1997)
   %
   % Entradas: una matriz X de dimension nxp.
   % Salidas: una matriz D de dimension nxn.
   %
   % atencion! esta version solo vale para p=2
   %
   function [D,S]=robustG_maha(X)
   [n,p]=size(X);  
   % muestra recortada al 5% por cada extremo
   S=zeros(p);
   for i=1:p
       qinf=quantile(X(:,i),0.025); qsup=quantile(X(:,i),0.975);
       ntrim=find((qinf<=X(:,i))& (X(:,i)<=qsup));
       Xtrim=X(ntrim,i);
       S(i,i)=var(Xtrim);
   end    
   for i=1:p
       for j=i+1:p
          Y1=X(:,i)+X(:,j);        
          qinf=quantile(Y1,0.025); qsup=quantile(Y1,0.975);
          n1trim=find((qinf<=Y1)& (Y1<=qsup));
          Y1trim=Y1(n1trim);
          sigma1=var(Y1trim);
          clear qinf qsup Y1trim n1trim
          Y2=X(:,i)-X(:,j);
          qinf=quantile(Y2,0.025); qsup=quantile(Y2,0.975);
          n2trim=find((qinf<=Y2)& (Y2<=qsup));
          Y2trim=Y2(n2trim);
          sigma2=var(Y2trim);
          clear qinf qsup Y2trim n2trim
          S(i,j)=(sigma1-sigma2)/4;
          S(j,i)=S(i,j);
          clear sigma1 sigma2
       end
   end    
   % calculo de las distancias de Mahalanobis (al cuadrado):
   D=zeros(n);
   invS=inv(S);
   for i=1:n
      for j=i+1:n
         D(i,j)=(X(i,:)-X(j,:))*invS*(X(i,:)-X(j,:))';
      end
   end
   D=D+D';