% CramerV
% This function computes Cramers' V association coefficient between a
% multi-state nominal variable and a quantitative variable evaluated on
% the same group of individuals.
%
function V=CramerV(u,X)
n=length(u);
p=[0 25 50 75 100];
q=prctile(X,p);
Xcat=ones(n,1);
Xcat(find(X>q(2) & X<=q(3)))=2;
Xcat(find(X>q(3) & X<=q(4)))=3;
Xcat(find(X>q(4)))=4;
[table,chi2,pvalue] = crosstab(u,Xcat);
k=length(unique(u));
r=length(unique(Xcat));
V=sqrt(chi2/(n*min(k-1,r-1)));