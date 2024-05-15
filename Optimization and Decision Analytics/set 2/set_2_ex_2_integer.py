# -*- coding: utf-8 -*-
"""
Created on Mon Oct 16 17:54:00 2023

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

x = model.addVars(oneton, name="x", vtype=GRB.BINARY)

model.addConstr(quicksum(A[i] * x[i] for i in oneton) <= 125)

model.addConstrs((x[j] <= 1 for j in oneton))

obj = quicksum(r[i] * x[i] for i in oneton)

model.setObjective(obj, GRB.MAXIMIZE)

# disable Presolve
model.setParam(GRB.Param.Presolve, 0)
# disable Heuristics
model.setParam(GRB.Param.Heuristics, 0)
# disable Cuts
model.setParam(GRB.Param.Cuts, 0)

model.optimize()




# Display solution (print the name of each variable and the solution value)
print('--------------------------------')
print('\nOptimal solution:\n')

print('Variable Information:')
                 
for v in model.getVars():
    print("%s %s %8.2f" % 
              (v.Varname, "=", v.X))
    
    print(" ")
        
print('\nOptimal objective value: %g' % model.objVal)