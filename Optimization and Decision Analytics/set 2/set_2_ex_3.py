# -*- coding: utf-8 -*-
"""
Created on Mon Oct 16 16:51:26 2023

@author: alema
"""

from gurobipy import *
import numpy as np
import itertools

n = 8

oneton = range(1, n+1)


ciudades = ['Alicante', 'Almeria', 'Barcelona', 'Cordoba',
            'Granada', 'La Coruna', 'Madrid', 'Cuenca']
N = set(ciudades)

dist = np.empty((n,n))
dist[0,1:] = [295, 508, 505, 348, 867, 419, 305]
dist[1,2:] = [790, 315, 166, 883, 582, 520]
dist[2,3:] = [860,844,894,619,539]
dist[3,4:] = [166,976,298,333]
dist[4,5:] = [799,361,345]
dist[5,6:] = [510,636]
dist[6,7:] = [165]

for (i,j) in itertools.product(oneton, oneton):
    dist[j-1,i-1] = dist[i-1,j-1]
    
for i in oneton:
    dist[i-1,i-1] = 0
    

road, dist = multidict({(ciudades[i-1],ciudades[j-1]): dist[i-1,j-1] for (i,j) in itertools.product(oneton, oneton)})



model = Model("Set 2 - Problem 3")



x = model.addVars(road, obj=dist, name="x", vtype=GRB.BINARY)
    
model.addConstrs((quicksum(x[i,j] for j in ciudades if j != i) == 1 for i in ciudades),
                 "Arrows in")

model.addConstrs((quicksum(x[j, i] for j in ciudades if j != i) == 1 for i in ciudades),
                 "Arrows out")


# first iteration
s = {'Almeria', 'Barcelona'}
s_not = N - s

model.addConstr((quicksum(quicksum(x[i,j] for i in s) for j in s_not) >= 1), 
                name='S_0')

# second iteration
s = {'La Coruna','Madrid'}
s_not = N - s

model.addConstr((quicksum(quicksum(x[i,j] for i in s) for j in s_not) >= 1), 
                name='S_1')

# third iteration
s = {'Almeria','Cordoba','Granada'}
s_not = N - s

model.addConstr((quicksum(quicksum(x[i,j] for i in s) for j in s_not) >= 1), 
                name='S_2')

# fourth iteration
s = {'Cordoba','Granada'}
s_not = N - s

model.addConstr((quicksum(quicksum(x[i,j] for i in s) for j in s_not) >= 1), 
                name='S_3')

obj = quicksum((dist[i,j] * x[i,j] for i,j in road))

model.setObjective(obj, GRB.MINIMIZE)

model.optimize()

# Display solution (print the name of each variable and the solution value)
print('--------------------------------')
print('\nOptimal solution:\n')

print('Variable Information:')
                 
for v in model.getVars():
    if v.X != 0:
        print("%s %s %8.2f" % 
              (v.Varname, "=", v.X))
    
        #print(" ")
        
print('\nOptimal objective value: %g' % model.objVal)