% fucntion PCAcovstability
% this function performs a stability study on PCA's by leave-one-out 
% PCA is computed by means of the sample covariance matrix
%
function rowsummary=PCAcovstability(X)
[n,p]=size(X);
H=eye(n)-ones(n)/n;
X=H*X;
S=cov(X,1);
[T,D]=eigsort(S);
% control of the signs of the components
for j=1:p
   if T(1,j)<0
      T(:,j)=-T(:,j);
   end
end
Y=X*T;
% leave-one-ot
for i=1:n
   Xi=[X(1:i-1,:); X(i+1:n,:)];
   Si=cov(Xi,1);
   [Ti,Di]=eigsort(Si);       
% control of the signs of the components
   for j=1:p
      if Ti(1,j)<0
         Ti(:,j)=-Ti(:,j);
       end
   end 
   Yi=Xi*Ti;
   y=X(i,:)*Ti;  
   Yplusi=[Yi(1:i-1,:); y; Yi(i:n-1,:)];
% Euclidean distance of each unit among configurations
   for k=1:n
      v(k,i)=(Yplusi(k,:)-Y(k,:))*(Yplusi(k,:)-Y(k,:))';
   end    
end 
% i-th row in matrx v contains the configuration for the i-th unit
v=sqrt(v);  
% summary statistics for the rows of v
for i=1:n
   Rad(i,1)=min(v(i,:));
   Rad(i,2)=max(v(i,:));
   Rad(i,3)=quantile(v(i,:),0.50);
   Rad(i,4)=quantile(v(i,:),0.75);
   Rad(i,5)=quantile(v(i,:),0.90);
   Rad(i,6)=quantile(v(i,:),0.95); 
end
% some summary statistics by rows
rowsummary=[mean(Rad); std(Rad); median(Rad); mad(Rad,1)]; 
%
% PCA unit stability 
figure
subplot(2,1,1)
boxplot(v)
title('Euclidean distance of each unit among configurations')
%
for i=1:n
  lab(i,:)=sprintf('%3g',i);
end
radius=Rad(:,5); % it also could be Rad(:,6)
for i=0:0.01:2*pi
    theta(floor(i*100+1))=i;
end
%
subplot(2,1,2)
plot(Y(:,1),Y(:,2),'.b')
title('PCA representation with 90% stability regions')
xlabel('PC1')
ylabel('PC2')
for i=1:n
     text(Y(i,1),Y(i,2),lab(i,:));
end
hold on
for i=1:n
   for j=1:length(theta)
        circle(j,1)=Y(i,1)+cos(theta(j))*radius(i);
        circle(j,2)=Y(i,2)+sin(theta(j))*radius(i);
   end
   plot(circle(:,1),circle(:,2),'.k','MarkerSize',2)
end
end

