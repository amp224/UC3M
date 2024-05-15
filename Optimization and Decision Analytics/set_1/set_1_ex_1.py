# -*- coding: utf-8 -*-
"""
Created on Thu Oct  5 17:14:44 2023

@author: alema
"""

from gurobipy import *


m = 2 # number of resources
n = 4 # number of products

resources = range(1, m+1) # list [1, ..., m]

products = range(1, n+1)  # list [1, ..., n]

# primal objective coefficients

r_coeff = [2.0, 3.0, 9.0, 6.0] 

# left-hand side (LHS) coefficients (matrix A)

A_coeff = [[4.0, 1.0, 8.0, 2.0],
           [2.0, 3.0, 4.0, 6.0]]

# right-hand side (RHS) coefficients

b_coeff = [30.0, 60.0]

r = {j : r_coeff[j-1] for j in products}

A = {i : {j : A_coeff[i-1][j-1] for j in products} 
    for i in resources}

b = {i : b_coeff[i-1] for i in resources}

model = Model('Set 1 Problem 1')

x = model.addVars(products, name="x") # quantity produced

# Constraints
model.addConstrs((quicksum(A[i][j] * x[j] for j in products)
                           == b[i] 
                            for i in resources), name = "pi")

# Objective
obj = quicksum(r[j] * x[j] for j in products)

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