% graphical outputs
%
% let dataset be a matrix nxp containing the data to be plotted
[n,p]=size(dataset);
for i=1:n
  lab(i,:)=sprintf('%3g',i);
end
%----------------------------------------------------------------
% simple scatterplot with labels and horizontal or diagonal lines
%----------------------------------------------------------------
figure
plot(dataset(:,1),dataset(:,2),'ob')
hold on
for i=1:n
     text(dataset(i,1),dataset(i,2),lab(i,:));
end
% to add the axes and labels conveniently
% axis([-15 15 -15 15])
% xlabel('Y1','FontSize',10)
% ylabel('Y2','FontSize',10)
grid
% to add additional horizontal or diagonal lines 
%yline(0,'Color','black','LineStyle','-')
%line([-15 15],[-15 15],'Color','black','LineStyle','-')
%----------------------------------------------------------------
% multiple scatterplots
%----------------------------------------------------------------
figure
subplot(1,2,1)
plotmatrix(X)
xlabel('original','FontSize',10)
subplot(1,2,2)
plotmatrix([log(X(:,1:3)) X(:,4)])
xlabel('X1-X3 log transformed, X4 original','FontSize',10)
%----------------------------------------------------------------
% comparisons of distances
%----------------------------------------------------------------
figure
plot(d_euclid1,d_euclid1,'-k')
hold on
plot(d_euclid1,d_city1,'+b')
plot(d_euclid1,d_mink41,'or')
xlabel('Euclidean distance')
ylabel('other L-q distance')
figure
plot(d_euclid1,d_euclid1,'-k')
hold on
plot(d_euclid1,d_pearson1,'^b')
plot(d_euclid1,d_maha1,'sr')
xlabel('Euclidean distance')
ylabel('other distance')
figure
plot(d_euclid1,d_euclid1,'-k')
hold on
plot(d_euclid1,d_euclid3,'+b')
xlabel('Euclidean distance original dataset')
ylabel('Euclidean distance redundant dataset')
figure
plot(d_maha1,d_maha1,'-k')
hold on
plot(d_maha1,d_maha3,'+b')
xlabel('Mahalanobis distance original dataset')
ylabel('Mahalanobis distance redundant dataset')
%----------------------------------------------------------------
% comparisons of similarities
%----------------------------------------------------------------
[d,i]=sort(squareform(Deuclid));
DSC1=squareform(DSC1);
DSC4=squareform(DSC4);
figure
plot(d,'-b','LineWidth',1.5)
hold on
plot(DSC1(i),'-.g','LineWidth',1.5)
plot(DSC4(i),'--r','LineWidth',1.5)
xlabel('pairs of units (ordered by pairwise Euclidean distance)')
ylabel('distance values')
%----------------------------------------------------------------
% comparison of Gower and joint metric (squared distances)
%----------------------------------------------------------------
[dg,i]=sort(squareform(Dgower2));
d=squareform(D2); djoint=squareform(Djoint2);
figure
plot(dg,'-b','LineWidth',1.5)
hold on
plot(d(i),'--r','LineWidth',1.5)
plot(djoint(i),'.-g','LineWidth',1.5)
xlabel('pairs of units ordered by Gower distance')
ylabel('distance values')
legend('Gower','Pythagorean sum','RelMS', 'Location','best')
%-----------------------------------------------------------------
% comparison of dendrograms
%-----------------------------------------------------------------
label={'Mozzarella','Camembert','Cheddar','Processed','Edam','Emmental','Gouda','Gruyere','Parmesan','Provolone','Roquefort'}
data=cheesesData;
d=pdist(data,'mahal');
Umin=linkage(d,'single');
Umax=linkage(d,'complete');
Uave=linkage(d,'average');
figure
subplot(3,1,1)
dendrogram(Umin,0,'Labels',label,'orientation','left')
title('Single linkage')
subplot(3,1,2)
dendrogram(Umax,0,'Labels',label,'orientation','left')
title('Complete linkage')
subplot(3,1,3)
dendrogram(Uave,0,'Labels',label,'orientation','left')
title('Average linkage')