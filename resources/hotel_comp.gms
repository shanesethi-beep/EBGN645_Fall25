* comparing PC and monopoly extraction

SETS
    t /0*50/;

SCALARS
    pbar reference price /10/
    R0 resource stock /100/ 
    a demand curve intercept /6/   
    b demand curve slope /0.1/  
    c cost multiplier /8/    
    r discount rate /%rate%/ 
;

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


* Objective functions: Maximize profits
obj_def_comp..
    obj_comp =E= SUM(t, delta(t) * (pbar * q_comp(t) - c * q_comp(t) * q_comp(t) / R0));

obj_def_mon..
    obj_mon =E= SUM(t, delta(t) * ((a - b*q_mon(t)) * q_mon(t) - c * q_mon(t) * q_mon(t) / R0));

* Resource constraints
stock_constraint_comp..
    SUM(t, q_comp(t)) =L= R0;

stock_constraint_mon..
    SUM(t, q_mon(t)) =L= R0;

* Model Definitions
MODEL perfect_competition /all/;
MODEL monopoly /all/;

parameter rep; 

* Solve Models
SOLVE perfect_competition USING NLP MAXIMIZING obj_comp;
rep("q","comp",t) = q_comp.l(t) ; 
rep("p","comp",t) = a - b * q_comp.l(t) ; 

SOLVE monopoly USING NLP MAXIMIZING obj_mon;
rep("q","mon",t) = q_mon.l(t) ; 
rep("p","mon",t) = a - b * q_mon.l(t) ; 


execute_unload 'hotel_%rate%.gdx' ; 