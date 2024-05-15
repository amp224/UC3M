%
% sensitividad_Gower
%
% estudio de sensitividad: metodo leave-one-out
%
function sensitividad_Gower(Xdat,p1,p2)
%
[n,p]=size(Xdat);
% p3 numero de variables cualitativas
p3=p-p1-p2;
%
% similaridad de Gower
S=gower2(Xdat,p1,p2,p3);
% matriz de cuadrados de distancias (dist. Gower)
D=ones(n)-S; 
% coordenadas principales del conjunto completo
[Ycomplet,percentacum]=coorp_complet(D);
% estudio de estabilidad: metodo leave-one-out
for i=1:n
   Xdati=[Xdat(1:i-1,:); Xdat(i+1:n,:)];
   Si=gower2(Xdati,p1,p2,p3); 
   Di=ones(n-1)-Si;
   % coordenadas principales del conjunto Xdat sin el individuo i-esimo
   [Y,Lambda0]=coorp_minus(Di);
   g=diag(Y*Y')';
   d=[D(1:i-1,i); D(i+1:n,i)]';
   % proyeccion del individuo i-esimo (formula de interpolacion de Gower)
   y=1/2*(g-d)*Y*inv(Lambda0);
   % insercion del individuo i-esimo en el conjunto Xdati
   Yplusi=[Y(1:i-1,:); y; Y(i:n-1,:)];
   % distancia euclidea (al cuadrado) de cada punto entre sus distintas configuraciones
   for j=1:n
      v(j,i)=(Yplusi(j,:)-Ycomplet(j,:))*(Yplusi(j,:)-Ycomplet(j,:))';
   end
end
v=sqrt(v);
% radios de las hiperesferas
for j=1:n
   radius(j)=quantile(v(j,:),0.95); % podria ser tambien 0.90
end
for i=0:0.12:2*pi
    theta(floor(i*100+1))=i;
end    
%-------------------------------------------
% representacion grafica en dimension 2
figure (1)
 plot(Ycomplet(:,1),Ycomplet(:,2),'.b')
 hold on
 for i=1:n
     for j=1:length(theta)
         circle(j,1)=Ycomplet(i,1)+cos(theta(j))*radius(i);
         circle(j,2)=Ycomplet(i,2)+sin(theta(j))*radius(i);
     end
     plot(circle(:,1),circle(:,2),'.k','MarkerSize',4)
 end
 title(['Porcentaje de variabilidad explicada ',num2str(percentacum),'%'],'FontSize',12)
hold off