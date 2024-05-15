# Task 3
#Luisa Ripoll Alberola and Alejandro Macías Pastor

# Exercise I

#a = vector("numeric", length = 29) # for i=1:29 j = j+1 being j(0)=10 
#j = 9

#for(i in 1:29){
#  a[i] = j + 1; 
#  j = j + 1
#}

a = 10:38
a

b = 30:1
b

c = c(1:4,3:1)
c

d = seq(2,20,2)
d

#e = c(1:3)
#for(i in 1:9){
#  e = append(e,1:3)
#}
e = rep(1:3, times = 10)
e

#The idea getting f should be "eliminate" the two last components, but I don't get 
#the result. 
f = e[-c(29,30)]
f

#Other way to get it:
#f = rep(1:3, times=9)
#f = append(f,1)
#f

g = paste("label", 1:30)
g

h = paste("label", 1:30, sep = "-")
h

# x2ex , x = 0.1, 0.2, . . . , 1
#I don't get it
# xi = seq(0.1,1,0.1)
# func = function(x)x^2*e^(x)
# i = vector("numeric", length=length(xi))
# for(j=1:length(xi)){
#   i[j]=func(xi[j])
# }
# i = func(xi)
i

# Exercise II

#first sumatory
sum11 = 0
for(j in 5:23){
  sum11 = sum11+j^2+3*sqrt(j) 
}
sum11

j=5:23
sum12=sum(j^2 + 3 * sqrt(j))
sum12

#second sumatory
sum21 = 0
for(i in 1:18){
  sum21 = sum21 + 1.3^i/i
}
sum21

j2 = 1:18
sum22 = sum(1.3^(j2)/j2)
sum22

#third sumatory
sum31 = 0
for(i in 1:10){
  for(j in 1:6){
    sum31 = sum31 + i^4/(3+j)
  }
}
sum31

i_values=1:10
j_values=1:6
inner_sum=function(i, j) {
  i^4 / (3 + j)
}
sum32 = sum(outer(i_values, j_values, Vectorize(inner_sum)))
sum32 

#Exercise III

#a) Explain the following code: 

set.seed(75) #When generating random numbers in R, it is necessary, to get the 
#same result each time we compute the code, to set a seed. This is possible 
#because random numbers in R are not random but pseudorandom numbers, obtained 
#recursively using an algorithm. 
M = matrix(sample(1:10, size=60, replace=TRUE), nrow=6, ncol=10) #A matrix of 
#6 rows and 10 columns is defined. Its components are random generated numbers 
#from 1 to 10, with replacement.
M

#b) Find the number of entries which are greater than 4.

num = 0
num = sum(M>4)
num

#c) Replace the third column of the previous vector M 

M[,3]=M[,2]+M[,3]
M

#Exercise IV

double_odd = function(M){
  M[M%%2==1]=M[M%%2==1]*2
  return(M)
}

double_odd(M)