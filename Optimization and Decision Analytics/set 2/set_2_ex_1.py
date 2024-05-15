# -*- coding: utf-8 -*-
"""
Created on Mon Oct 16 16:51:05 2023

@author: alema
"""

from gurobipy import *

n = 3

oneton = range(1, n+1)

# Resource availability and usage for each type of product
usage = [[12, 15, 10],
         [15, 14, 12],  
         [11, 13, 9 ],
         [13, 12, 15]]

availability = [1500, 1900, 1800, 1200]

# piecewise prices (and their quantities) for each product
fixed_prices = [40, 50, 45]
# Product 1 -> i=1,2; Product 2-> i=3,4; Product 3-> i=5,6,7
prices = [4, 3, 6, 4, 5, 2.5, 1] 
quantities = [10, 50, 8, 52, 10, 10, 40]

prices = {j: prices[j-1] for j in range(1, len(prices)+1)}
fixed_p = {j: fixed_prices[j-1] for j in oneton}
quantities = {j: quantities[j-1] for j in range(1, len(quantities)+1)}
m = Model("Set 2 - Problem 1")

x = m.addVars(oneton, name='x', lb=0,  ub=60, vtype=GRB.INTEGER)

# Variables to account for fixed prices
t = m.addVars(oneton, name='t', vtype=GRB.BINARY)
m.addConstrs(((x[i] <= 60*t[i]) for i in oneton), name='Fixed prices')


# Constrainsts from resource availability
m.addConstrs((quicksum(usage[i-1][j-1] * x[j] for j in oneton) <= availability[i-1]
              for i in range(1, 4+1)), name='Resource availability')


# If-then condition: if x_3 > 0, then x_1 > 0
# logically equivalent to: if x_1 = 0, then x_3 = 0
d = m.addVar(1, name='d', vtype=GRB.BINARY)
utils = [1,3]
m.addConstr((x[3] <= 60*t[1]), name='x1=0 => x3=0')


# Variables to formulate piece-wise prices
utils = range(1, 7+1)
y = m.addVars(utils, name='y', vtype=GRB.BINARY)
z = m.addVars(utils, name='z', lb=0, vtype=GRB.INTEGER)


# Variables and constraints for Product 1
utils = [1,2]
m.addConstr((quicksum(y[i] for i in utils) == 1), name='y1 + y2 = 1')
m.addConstr((quicksum(z[i] for i in utils) == x[1]), name='z1 + z2 = x1')
m.addConstr((z[1] <= 10*y[1]), name='z1 <= 10y1')
m.addConstr((10*y[2] <= z[2]), name='10y2 <= z2')
m.addConstr((z[2] <= 60*y[2]), name='z2 <= 60y2')


# Variables and constraints for Product 2
utils = [3,4]
m.addConstr((quicksum(y[i] for i in utils) == 1), name='y3 + y4 = 1')
m.addConstr((quicksum(z[i] for i in utils) == x[2]), name='z3 + z4 = x2')
m.addConstr((z[3] <= 8*y[3]), name='z3 <= 8y3')
m.addConstr((8*y[4] <= z[4]), name='8y4 <= z4')
m.addConstr((z[4] <= 60*y[4]), name='z4 <= 60y4')


# Variables and constraints for Product 3
utils = [5,6,7]
m.addConstr((quicksum(y[i] for i in utils) == 1), name='y5 + y6 + y7 = 1')
m.addConstr((quicksum(z[i] for i in utils) == x[3]), name='z5 + z6 + z7 = x3')
m.addConstr((z[5] <= 10*y[5]), name='z5 <= 10y5')
m.addConstr((10*y[6] <= z[6]), name='10y6 <= z6')
m.addConstr((z[6] <= 20*y[6]), name='z6 <= 20y6')
m.addConstr((20*y[7] <= z[7]), name='20y7 <= z7')
m.addConstr((z[7] <= 60*y[7]), name='z7 <= 60y7')


# Objective function
utils = range(1, 7+1)
obj = -quicksum(fixed_p[i] * t[i] for i in oneton) +\
      quicksum(prices[i] * z[i] for i in utils) +\
      prices[1]*quantities[1]*y[2] - prices[2]*quantities[1]*y[2] +\
      prices[3]*quantities[3]*y[4] - prices[4]*quantities[3]*y[4] +\
      prices[5]*quantities[5]*y[6] - prices[6]*quantities[5]*y[6] +\
      (prices[5]*quantities[5] + prices[6]*quantities[6])*y[7] -\
      prices[7]*(quantities[5] + quantities[6]) * y[7]

m.setObjective(obj, GRB.MAXIMIZE)

# disable Presolve
m.setParam(GRB.Param.Presolve, 0)
# disable Heuristics
m.setParam(GRB.Param.Heuristics, 0)
# disable Cuts
m.setParam(GRB.Param.Cuts, 0)

m.optimize()


# Display solution (print the name of each variable and the solution value)
print('--------------------------------')
print('\nOptimal solution:\n')

print('Variable Information:')
                 
for v in m.getVars():
    print("%s %s %8.2f" % 
              (v.Varname, "=", v.X))
    
    print(" ")
        
print('\nOptimal objective value: %g' % m.objVal)




