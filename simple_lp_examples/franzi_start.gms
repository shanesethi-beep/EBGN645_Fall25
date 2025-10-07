$TITLE Franzi 

*-- sets/indices --

set t "time" /0*30/
*    t0(t) "our first year" /0/
    t0(t) "our first year"
    tlast(t) "our last year"
 ; 
 
 alias(t,tt,ttt) ; 

set tprev(t,tt) "tt is the previous year to t" ; 

tprev(t,tt)$[tt.val = t.val-1] = yes ; 
t0(t)$[t.val=smin(tt,tt.val)] = yes ; 
tlast(t)$[t.val=smax(tt,tt.val)] = yes ; 

*--- Data ---
scalar 
    p  "sale price ($/tree)" /100/ 
    g  "annual growth rate for trees (%)" /%grate%/
    s0 "initial stock of trees (trees)" /100/ 
    r  "discount rate (%)" /%rrate%/ 
; 

g = 1+g ; 

parameter delta(t) ; 
delta(t) = 1/((1+r)**t.val) ; 

positive variables
H(t) "number of trees harvest"
S(t) "stock of trees available"
;
 
Variable profit ; 

equation
eq_objfn,
eq_harvestlimit(t),
eq_stocktrack(t);

eq_objfn.. profit =e= sum(t,p * delta(t) * H(t) ) 
                     + sum(t$tlast(t),delta(t)*p*S(t)); 

eq_harvestlimit(t).. S(t) =g= H(t) ; 

eq_stocktrack(t)..
    S(t) =e=
    s0$t0(t)
    + g *(S(t-1) - H(t-1))$(not t0(t)) 
;

equation force_stock ;
scalar sw_force "use the force luke" /1/ ; 
force_stock$sw_force.. S("20") =g= 100 ; 

model franzi /all/ ; 

solve franzi using LP maximizing profit ; 


parameter rep;

rep("%grate%","%rrate%",t,"H") = h.l(t) ; 
rep("%grate%","%rrate%",t,"S") = s.l(t) ; 

execute_unload 'franzi_data_%grate%_%rrate%.gdx' ; 

