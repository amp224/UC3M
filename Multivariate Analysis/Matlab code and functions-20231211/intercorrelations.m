function q=intercorrelations(X)
   [n,p]=size (X);
   R=corr(X);
   q=zeros(1,6);
   lambda= eig(R); 
   rjj=diag(inv(R));
   q(1)=(1-min(lambda)/max(lambda))^(p+2);
   q(2)=1-p/sum(1./lambda);
   q(3)=1-sqrt(det(R));
   q(4)=(max(lambda)/p)^(3/2);
   q(5)=(1-min(lambda)/p)^5;
   q(6)=sum((1-1./rjj)/p);
   %
   figure
   plotmatrix(X)
   end