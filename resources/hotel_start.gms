* comparing PC and monopoly extraction

SETS
    t /0*50/;

$if not set rate $setglobal rate 5

SCALARS
    pbar reference price /10/
    R0 resource stock /100/ 
    a demand curve intercept /6/   
    b demand curve slope /0.1/  
    c cost multiplier /8/    
    r discount rate /%rate%/ 
;
r = r / 100 ; 

parameter delta(t) ; 
delta(t) = 1/((1+r)**t.val) ; 


POSITIVE VARIABLES
    q(t) ; 

variables
    obj_comp  
    obj_mon   ;

EQUATIONS
    obj_def_comp, 
    obj_def_mon,

    stock_constraint ; 

obj_def_comp.. obj_comp =e= sum(t,delta(t) *( pbar * q(t) - c * q(t) * q(t) / R0) ); 

obj_def_mon.. obj_mon =e= sum(t,delta(t) * (a * q(t) + b * q(t) * q(t) / 2) - c * q(t) * q(t) / R0) ; 

stock_constraint..  R0 =g= sum(t, q(t)) ; 

model hotel /all/ ; 

parameter rep ; 

solve hotel using qcp maximizing obj_comp ; 

rep("comp",t) = q.l(t) ; 

solve hotel using qcp maximizing obj_mon ; 
rep("monopolist",t) = q.l(t) ; 

execute_unload 'hotel_%rate%.gdx' ; 