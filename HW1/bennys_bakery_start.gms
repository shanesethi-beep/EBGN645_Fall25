
set i /roll, croissant, loaf/ ;

parameter 
r(i) "revenue per item ($/item)"
/
    roll 2.25
    croissant 5.5
    loaf 10
/,

c(i) "cost per item ($/item)"
/
    roll 1.5
    croissant 2
    loaf 5
/,

h(i) "hour requirement per item (hour / item)"
/
    roll 1.5
    croissant 2.25
    loaf 5
/;

scalar hbar "total hours in a week" /40/ ; 
scalar sw_combo /0/ ;

positive variable X(i) "items produced (items)"; 
Variable profit "total profit - target of our optimization ($s)" ;

equation
eq_objfn
eq_hourlimit
eq_combo
;

eq_objfn.. profit =e= sum(i,(r(i)-c(i))*X(i)) ;

eq_hourlimit.. hbar =g= sum(i,h(i) * X(i)) ; 

eq_combo$sw_combo.. X("roll") =g= X("croissant") ; 

model benny /all/ ; 

solve benny using lp maximizing profit ; 

parameter report ; 
report(i,"nocombo") = x.l(i) ; 
report("profit","nocombo") = profit.l ; 


sw_combo = 1 ; 
solve benny using lp maximizing profit ; 
report(i,"withcombo") = x.l(i) ; 
report("profit","withcombo") = profit.l ; 

execute_unload 'benny.gdx' ;





