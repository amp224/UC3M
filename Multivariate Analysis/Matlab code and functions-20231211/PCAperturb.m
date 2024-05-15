% fucntion PCAperturb
% this function performs the perturbation study on PCA's detailed in Krzanwski (1984b)
%
% Entries:
% D: the vector of eigenvalues to be perturbed  
% T: the matix whose columns are the eigenvectors to be perturbed
% alpha: is value in (0,1)-interval with the percentage of perturbation 
%
function PCAperturb=(D,T,alpha)
p=length(D); 
Tp=T; Dp=D;
for i=1:p
    epsilon=D(i)*alpha;
    Dp(i)=D(i)-epsilon;
    Tper(:,j)=
    


