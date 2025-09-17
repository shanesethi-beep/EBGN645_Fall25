OPTION PROFILE=1
set i /hamburgers,hotdogs,frenchfries/ ; 

parameter 
r(i) "--$/item-- revenue per unit sold"
/
hamburgers 1.5,
hotdogs 0.75,
frenchfries 0.25
/ ;

parameter c(i) "--$/item-- cost per unit sold"
/
hamburgers 0.75,
hotdogs 0.1,
frenchfries 0.05
/ ;

parameter h(i) "--hours/item-- hours required per item sold"
/
hamburgers 0.5,
hotdogs 0.2,
frenchfries 0.1
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

eq_hourlimit.. hbar =g= sum(i,h(i) * X(i)) ; 

scalar sw_combo_newname /%combo%/ ; 

equation eq_combo;
eq_combo$sw_combo_newname.. X("frenchfries") =g= X("hotdogs") ;

equation eq_combo_wombo ; 

eq_combo_wombo$[sw_combo_newname=2].. X("frenchfries") =g= 2 * X("hotdogs") ;

set j "inputs" /Bun, Cheese, Beef, Sausage, Potato/ ; 
table inputs_in(j,i)
$ondelim
$include ripley_inputs.csv
$offdelim
;

parameter io(i,j) ; 

io(i,j)$inputs_in(j,i) = inputs_in(j,i) ; 

positive variables inputs(i,j) ; 
equation inputs_track(i,j) ; 

scalar sparse /%sparse%/ ; 

inputs_track(i,j)$io(i,j).. inputs(i,j) =e= io(i,j) * X(i) ; 

model ripley /all/ ; 

solve ripley using lp maximizing profit ;
* hello shane
execute_unload 'ripleysdata_%combo%.gdx' ; 

$exit


parameter rep ; 
rep(i) = X.l(i) ; 

