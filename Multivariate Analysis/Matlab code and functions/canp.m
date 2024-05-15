%
% CANP
%
% La funcion [mY,V,B,W,percent,Test1,texto1,Test2,texto2]=canp(X,n) 
% realiza el analisis canonico de g poblaciones, es decir, 
% representa las g poblaciones de forma optima a lo largo de 
% unos ejes canonicos ortogonales. 
% Para cada poblacion i (i=1,2,...,g) se tienen las medidas de 
% p variables X1,X2,...,Xp sobre n(i) individuos, 
% con n(1)+n(2)+...+n(g)=N.
%
% Entradas:
% X: es una matriz (N,p) que contiene las observaciones de p
%    variables (en columna) sobre los individuos de g poblaciones
%    (en fila),
% n: es un vector que contiene el numero de individuos de cada
%    poblacion.
%
% Salidas:
% mY: matriz que contiene las nuevas coordenadas de los
%     individuos medios (en fila),
% V:  matriz de vectores propios de B respecto de W (en columna),
%     es decir, las columnas de V definen los ejes canonicos,
% B:  matriz de dispersion entre poblaciones (between),
% W:  matriz de dispersion dentro de cada poblacion (within),
% percent: porcentaje de variabilidad explicado,
% Test1: vector que contiene el valor de la F de Fisher, sus
%     grados de libertad y el p-valor [F(n1,n2) n1 n2 p_valor1] 
%     obtenidos en el test de comparacion de medias,
% texto1: texto resumen del resultado de Test1,
% Test2: vector que contiene el valor de la chi-cuadrado, sus
%     grados de libertad y el p-valor [chi(q) q p_valor2] 
%     obtenidos en el test de comparacion de covarianzas,
% texto2: texto resumen del resultado de Test2.
%
 function [mY,V,B,W,percent,Test1,texto1,Test2,texto2]=canp(X,n)
 [N,p]=size(X);
 g=length(n);
 % vector de etiquetas para las poblaciones
 for i=1:g
   lab(i,:)=sprintf('%3g',i);
 end
% vector de etiquetas para los individuos
 for i=1:N
  labind(i,:)=sprintf('%3g',i);
 end
%
 n0(1)=n(1);
 for i=2:g
   n0(i)=n0(i-1)+n(i);
 end
%
% calculo de los individuos medios
%
 mX(1,:)=ones(1,n(1))*X(1:n0(1),:)/n(1);
 for i=2:g
   mX(i,:)=ones(1,n(i))*X(n0(i-1)+1:n0(i),:)/n(i);
 end
%
% calculo de la matriz de dispersion dentro de cada poblacion
%
 H1=eye(n(1))-ones(n(1))/n(1);
 W=X(1:n0(1),:)'*H1*X(1:n0(1),:);
 logH1=n(1)*log(det(W/n(1)));
 for i=2:g
   Hi=eye(n(i))-ones(n(i))/n(i);
   Ci=X(n0(i-1)+1:n0(i),:)'*Hi*X(n0(i-1)+1:n0(i),:);
   W=W+Ci;
   logH1=logH1+n(i)*log(det(Ci/n(i)));
 end
 S=W/(N-g);
%
% calculo de la matriz de dispersion entre poblaciones
%
 mmX0=n(1)*mX(1,:);
 for i=2:g
    mmX=mmX0+n(i)*mX(i,:);
    mmX0=mmX;
 end
 mmX=mmX/N;
 B0=n(1)*(mX(1,:)-mmX)'*(mX(1,:)-mmX);
 for i=2:g
    B=B0+n(i)*(mX(i,:)-mmX)'*(mX(i,:)-mmX);
    B0=B;
 end 
%
% Test de comparacion de medias (Lambda de Wilks).
% Conviene rechazar esta hipotesis.
%
 lambda=det(W)/det(W+B);
 [Fmit,n1,n2]=wilkstof(lambda,p,N-g,g-1);
 p_valor1=1-fcdf(Fmit,n1,n2);
 Test1=[Fmit n1 n2 p_valor1];
 texto1=char('Test1: Igualdad de medias (Lambda de Wilks): p-valor=',num2str(p_valor1));
%
% Test de comparacion de covarianzas (Razon de verosimilitudes
% sin la correccion de Box). Conviene no rechazar esta hipotesis.
%
 logH0=N*log(det(W/N));
 chi=abs(logH0-logH1);
 q=(g-1)*p*(p+1)/2;
 p_valor2=1-chi2cdf(chi,q);
 Test2=[chi q p_valor2];
texto2=char('Test2: Igualdad de covarianzas (test de Bartlett): p-valor=',num2str(p_valor2));
%
% calculo de los ejes canonicos
%
 [V,D]=eig(B,S);
 [z,i]=sort(-diag(real(D)));
 d=-z;
 V=real(V(:,i));
 m=min(g-1,p);
 V=V(:,1:m);
%
% estandarizacion de los ejes canonicos V'*S*V=Id.
 V=V*inv(diag(sqrt(diag(V'*S*V))));
%
% variabilidad explicada
%
 for i=1:m
   percent(i)=d(i)/sum(d)*100;
   acum(i)=sum(percent(1:i));
 end
%
% coordenadas de los individuos y de los individuos medios en los nuevos ejes
%
 Y=X*V(:,1:m);
 mY=mX*V(:,1:m);
%
% representacion de los individuos y de los individuos medios
%
 if m>=2
    group=ones(N,1); 
    for i=1:g-1
       group(sum(n(1:i))+1:sum(n(1:i+1)))=i+1;
    end     
   %plot(Y(:,1),Y(:,2),'.b','MarkerSize',15)
   gscatter(Y(:,1),Y(:,2),group)
   if N<=100
      for i=1:N
        text(Y(i,1),Y(i,2),labind(i,:));
      end
   end   
   hold on
   plot(mY(:,1),mY(:,2),'^k','MarkerFaceColor',[0 0 0])
   grid
   xlabel('1er. eje canonico','FontSize',10)
   ylabel('2o. eje canonico','FontSize',10)
%
   title(['Coordenadas canonicas (',num2str(acum(2)),'%)'],'FontSize',12)
   for i=1:g
      text(mY(i,1),mY(i,2),lab(i,:));
   end
 end
 end
%
%
%  funcion wilkstof
%
%  Esta funcion calcula la aproximacion asintotica de Rao de la
%  distribucion Lambda de Wilks, L(p,a,b), hacia la distribucion
%  F de Fihser-Snedecor, F(m,n).
%
%  [F,m,n]=wilkstof(L,p,a,b)
%
%  entradas: L es el valor de L(p,a,b)
%            p, a, b son los grados de libertad
%
%  salidas:  F es el valor de la F(m,n)
%            m, n son los grados de libertad
%
   function [F,m,n]=wilkstof(L,p,a,b)
   alpha=a+b-(p+b+1)/2;
   beta=sqrt((p^2*b^2-4)/(p^2+b^2-5));
   gamma=(p*b-2)/4;
   m=p*b;
   n=alpha*beta-2*gamma;
%  se redondea n al entero mas proximo
   if n-floor(n)<0.5
      n=floor(n);
   else
      n=floor(n)+1;
   end
   F=(1-L^(1/beta))/(L^(1/beta))*n/m;
   end
 
 