set i /hamburgers, hotdogs, frenchfries/ ; 

parameter p(i)

/
hamburgers 3, 
hotdogs 2, 
frenchfries 1
/;

scalar hbar 'hours in a week' /40/ ; 


parameter h(i)
/
hamburgers 2, 
hotdogs 1, 
frenchfries 0.5
/;

positive variable x(i) production ; 

variable z 'objective function' ; 

equation objfn, timelimit ; 

objfn.. Z =e= sum(i, p(i) * x(i)) ; 
timelimit.. hbar =g= sum(i,h(i) * x(i)) ; 

model ripley /all/ ; 

solve ripley using lp maximizing z ; 
