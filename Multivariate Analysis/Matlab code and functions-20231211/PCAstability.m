% fucntion PCAstability
% this function performs a stability study on PCA's by leave-one-out
%
% Entries:
% X: the dataset 
% parameter: 1 performs the analysis from covariance matrix 
%            2 performs the analysis from correlation matrix
%
function v=PCAstability=(X,parameter)
[n,p]=size(X);
H=eye(n)-ones(n)/n;
X=H*X;
if parameter==1
   S=cov(X,1);
   [T,D]=eigsort(S);
   Y=X*T;
   % control of the signs of the components
   for j=1:p
      if T(1,j)<0
        T(:,j)=-T(:,j);
      end
   end  
   % leave-one-ot
   for i=1:n
       Xdati=[Xdat(1:i-1,:); Xdat(i+1:n,:)];
       Si=cov(Xdati,1);
       [Ti,Di]=eigsort(Si);       
   % control of the signs of the components
       for j=1:p
          if Ti(1,j)<0
             Ti(:,j)=-Ti(:,j);
          end
       end 
       Yi=Xdait*Ti;
       y=X(i,:)*Ti;  
       Yplusi=[Yi(1:i-1,:); y; Yi(i:n-1,:)];
   end   
   % Euclidean distance of each unit between configurations
   for k=1:n
      v(k,i)=(Yplusi(k,:)-Y(k,:))*(Yplusi(k,:)-Y(k,:))';
   end    
      
else
   R=corr(X);
   [T,D]=eigsort(R);
   Y=X*T;
end 

end
  


