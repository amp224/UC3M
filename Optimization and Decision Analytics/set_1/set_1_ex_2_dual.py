# -*- coding: utf-8 -*-
"""
Created on Fri Oct  6 18:59:42 2023

@author: alema
"""

from gurobipy import *

n = 6 # number of observations

oneton = range(1, n+1)  # list [1, ..., n]


x_data = [[16.9, 17.1, 19.3, 16.8, 15.3, 25.2],
          [29.7, 30.9, 33.8, 31.8, 27.6, 35.9]]

y_data = [175.3, 177.8, 185.4, 175.3, 172.7, 198.5]

hand = {j : x_data[0][j-1] for j in oneton}

foot = {j : x_data[1][j-1] for j in oneton}

height = {j : y_data[j-1] for j in oneton}

model = Model('MAE dual')

pi = model.addVars(oneton, name='pi', lb=-1, ub=1)

model.addConstr((quicksum(pi) == 0), name='b0')

model.addConstr((quicksum(hand[i] * pi[i] for i in oneton) == 0), name='b1')
model.addConstr((quicksum(foot[i] * pi[i] for i in oneton) == 0), name='b2')

obj = quicksum(height[i] * pi[i] for i in oneton)

model.setObjective(obj, GRB.MAXIMIZE)

model.optimize()

# Display solution (print the name of each variable and the solution value)
print('--------------------------------')
print('\nOptimal solution:\n')

print('Variable Information Including Sensitivity Information:')

# tVars = PrettyTable(['Variable Name', ' Value', 'ReducedCost', 
#                     ' SensLow', ' SensUp'])  #column headers

for v in model.getVars():
    print("%s %s %8.2f %s %8.2f %s %8.2f %s %8.2f" % 
              (v.Varname, "=", v.X, ", reduced cost = ", abs(v.RC), ", from coeff = ", v.SAObjLow, "to coeff = ", v.SAObjUp))
    print(" ")
        
        
print('\nOptimal objective value: %g' % model.objVal)

print('\nOptimal shadow prices:\n')
for c in model.getConstrs():
        print("%s %s %8.2f %s %8.2f %s %8.2f" % (c.ConstrName, ": shadow price = ", c.Pi, ", from RHS = ", c.SARHSLow, "to RHS = ", c.SARHSUp))
        print(" ")



