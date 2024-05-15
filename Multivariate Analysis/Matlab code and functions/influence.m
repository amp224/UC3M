%
% influence
%
% Dada una matriz de datos X (nxp), la funcion influence(X,p1,p2)
% dibuja la influencia de las variables originales (columnas de X) en el plano de 
% representacion MDS formado por las dos primeras coordenadas principales.
%
% La representacion MDS se construye a partir de la distancia de
% Mahalanobis (si todas las columnas de X son cuantitativas) o de la
% distancia de Gower (si alguna de las columnas de X es cualitativa)
%
% Para obtener las curvas de influencia se utiliza la idea de los biplots no lineales 
% (Gower and Hand 1996).
%
% Entradas:  X matriz de datos originales
%            p1 numero de variables cuantitativas, 
%            p2 numero de variable binarias.
%
function influence(X,p1,p2)
[n,p]=size(X);
% p3 numero de variables cualitativas
p3=p-p1-p2;
% si solo hay variables cuantitativas, se calcula la distancia
% de Mahalanobis, en caso contrario se calcula la distancia de Gower
if p2+p3==0
    D=squareform(pdist(X,'mahal'));
    D2=D.*D;
else
    S=gower2(X,p1,p2,p3);
    D2=ones(n)-S;
end    
%
% coordenadas principales (sin graficos)
[Y,vaps,percent,acum] = coorp_sin(D2);
[nY,pY]=size(Y); 
v=1./vaps(1:pY); Lambda=diag(v);
g=diag(Y*Y')';
%
m0=min(X); m1=max(X);
if p2+p3==0 % si solo hay variables cuantitativas (dist. Mahal.)
   S=cov(X); invS=inv(S);
% influencia de la variable j-esima
   for k=1:p
% individuo virtual
      step=(m1(k)-m0(k))/50;
      Xnew(:,1)=m0(k):step:m1(k);  
      nXnew=length(Xnew);
      virtual=zeros(nXnew,p);
      virtual(:,k)=Xnew(:,1);
      for i=1:nXnew
         for j=1:n
         dnew(i,j)=(virtual(i,:)-X(j,:))*invS*(virtual(i,:)-X(j,:))';
         end
      end
% interpolacion de Gower   
      for i=1:nXnew   
         ynew(i,:)=1/2*(g-dnew(i,:))*Y*Lambda;
      end
%
      figure(1)
      plot(ynew(:,1),ynew(:,2))
      legend()
      title(['Influencia de las variables cuantitativas (Mahalanobis)'],'FontSize',12)
      hold on
      clear Xnew dnew ynew virtual step
   end
else % si hay variables cualitativas (dist. Gower)
% individuo virtual (variables cuantitativas)
    for k=1:p1
      step=(m1(k)-m0(k))/50;
      Xnew(:,1)=m0(k):step:m1(k);  
      nXnew=length(Xnew);
      virtual=zeros(nXnew,p);
      virtual(:,k)=Xnew(:,1);
      for i=1:nXnew
          Xvirtual=[X;virtual(i,:)];
          Snew=gower2(Xvirtual,p1,p2,p3);
          D2new=ones(n+1)-Snew;
          dnew(i,:)=D2new(n+1,1:n);
      end
% interpolacion de Gower
      for i=1:nXnew   
         ynew(i,:)=1/2*(g-dnew(i,:))*Y*Lambda;
      end
%
      figure(1)
      plot(ynew(:,1),ynew(:,2), 'o')
      title(['Influencia de las variables cuantitativas (Gower)'],'FontSize',12)
      legend('age','bgr','bu','sc','sod','hemo','pcv','wc','rc','rbc', ...
          'Location', 'southwest')
      hold on
      clear Xnew dnew ynew virtual Xvirtual Snew D2new step
    end   
% individuo virtual (variables binarias y cualitativas)
    for k=p1+1:p
%      Xnew(:,1)=m0(k):1:m1(k);
      Xnew(:,1)=unique(X(:,k));
      nXnew=length(Xnew);
      virtual=zeros(nXnew,p);
      virtual(:,k)=Xnew(:,1);
      for i=1:nXnew
          Xvirtual=[X;virtual(i,:)];
          Snew=gower2(Xvirtual,p1,p2,p3);
          D2new=ones(n+1)-Snew;
          dnew(i,:)=D2new(n+1,1:n);
      end
% interpolacion de Gower
      for i=1:nXnew   
         ynew(i,:)=1/2*(g-dnew(i,:))*Y*Lambda;
      end
%
      figure(2)
      plot(ynew(:,1),ynew(:,2), '-o')
      title(['Influencia de las variables cualitativas (Gower)'],'FontSize',12)
      legend('pc', 'pcc', 'ba', 'htn', 'dm', 'cad', 'appet', 'pe', ...
          'ane', 'class', 'bp', 'sg', 'al', 'su', ...
          'Location', 'southwest')
      hold on
      clear Xnew dnew ynew virtual Xvirtual Snew D2new
    end    
end
       