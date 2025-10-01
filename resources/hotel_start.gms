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
    q_comp(t) 
    q_mon(t)  ; 

variables
    obj_comp  
    obj_mon   ;

EQUATIONS
    obj_def_comp, 
    obj_def_mon,

    stock_constraint_comp, 
    stock_constraint_mon;


