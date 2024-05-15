% heatmap for sample correlation matrix
% R is the correlaton matrix to be plotted
function myheatmap(R)
h=heatmap(R);
mymap=[0 0 0.5
0 0.2 0.6
0 0.4 1
0.4 0.8 1
1 1 1
1 0.6 1
1 0.2 0.8
0.5 0 0.5
0.4 0 0.4];
h.Colormap=mymap;