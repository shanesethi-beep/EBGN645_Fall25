$title Ursula

set i 'goods' /pizza, beer/ ; 

scalar budget /20/ ; 

parameter p(i) 'price $/unit'
/
pizza 2
beer 4
/, 
alpha(i)
/
pizza 8
beer 10
/
beta(i)
/
pizza -1
beer -4
/; 

set b 'bins' /b1*b10/ ;
alias(b,bb) ; 
parameter u(i,b) ;  
u(i,b) = alpha(i) 
    + beta(i) * sum(bb$[ord(bb)<ord(b)],1) ; 




positive variable x(i,b) 'consumption of each good'; 
variable utility 'total utility' ; 

equation 
eq_objfn "objective function calculation",
eq_budgetlimit "ursula cant go hogwild",
eq_binlimit(i,b) ; 

eq_objfn.. 
utility =e= sum((i,b), u(i,b) * X(i,b)) ; 

eq_budgetlimit..
    budget =g= sum(i,p(i)*x(i)) ;

model ursula /all/ ; 

solve ursula using lp maximizing utility ; 