set i /roll, croissant, bread/ ;

parameter 
r(i) "--$/item-- revenue per unit sold"
/
roll 2.25,
croissant 5.5,
bread 10
/ ;

parameter c(i) "--$/item-- cost per unit sold"
/
roll 1.5,
croissant 2,
bread 5
/ ;

parameter h(i) "--hours/item-- hours required per item sold"
/
roll 1.5,
croissant 2.25,
bread 5
/ ;

scalar hbar "--hours-- total hours in a week" /40/; 

positive variable X(i) "--units-- production of units"; 
variable profit ; 

equation
eq_objfn "target of our optimization", 
eq_hourlimit "cant work more than 40 hours per week"
;

eq_objfn.. profit =e= sum(i,(r(i)-c(i)) * X(i)) ; 
* =e= "equal to"
* =g= "greater than"
* =l= "less than"
;

eq_hourlimit.. hbar =g= sum(i,h(i) * X(i)) ; 

equation eq_combo;
eq_combo$sw_combo_newname.. X("roll") =g= X("croissant") ;

equation eq_combo_wombo ; 

eq_combo_wombo$[sw_combo_newname=2].. X("roll") =g= 2 * X("croissant") ;

;

