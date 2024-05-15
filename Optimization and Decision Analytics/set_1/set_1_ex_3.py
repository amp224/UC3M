# -*- coding: utf-8 -*-
"""
Created on Fri Oct  6 19:42:44 2023

@author: alema
"""
from gurobipy import *

n = 8

oneton = range(1,n+1)

past_price = [15.68, 22.10, 30.39, 8.93, 40.55, 18.58, 22.54, 24.84]

pres_price = [31.80, 24.28, 32.50, 14.16, 50.99, 24.17, 23.67, 28.77]

esti_price = [29.50, 26.31, 34.55, 15.23, 62.43, 26.68, 23.85, 31.66]

past = {j : past_price[j-1] for j in oneton}
present = {j : pres_price[j-1] for j in oneton}
future = {j : esti_price[j-1] for j in oneton}

model = Model('Stocks')

x = model.addVars(oneton, name='Stocks sold', lb=0, ub=150)

model.addConstr((quicksum(0.99*present[i]*x[i] - 
                          0.3*(present[i] - past[i])*x[i] for i in oneton) == 10000),
                name='Down payment')

obj = quicksum((150 - x[i])*future[i] for i in oneton)

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
