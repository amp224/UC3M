# -*- coding: utf-8 -*-
"""
Created on Mon Oct 16 16:51:16 2023

@author: alema
"""

from gurobipy import *

# number of variables
n = 4

oneton = range(1,n+1)

# objective coefficients
r_coeff = [55, 32, 84, 75]

# LHS coefficients
A_coeff = [43, 27, 62, 81]

# RHS coefficients
b_coeff = 125

r = {j : r_coeff[j-1] for j in oneton}

A = {i : A_coeff[i-1] for i in oneton}

b = {1 : b_coeff}

model = Model("Set 2 - Problem 2: Initial Linear Relaxation")

x = model.addVars(oneton, lb=0, ub=1, name="x")

model.addConstr(quicksum(A[i] * x[i] for i in oneton) <= b[1])

# uncomment line below for first strengthening
model.addConstr(quicksum(x[i] for i in oneton) <= 2)

# uncomment line below for second strengthening
model.addConstr(x[3] + x[4] <= 1)


obj = quicksum(r[i] * x[i] for i in oneton)

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

