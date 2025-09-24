$TITLE Franzi 

*-- sets/indices --

set t "time" /0*30/
*    t0(t) "our first year" /0/
    t0(t) "our first year"
    tlast(t) "our last year"
 ; 
 
 alias(t,tt) ; 

set tprev(t,tt) "tt is the previous year to t" ; 

tprev(t,tt)$[tt.val = t.val-1] = yes ; 

t0(t)$[t.val=smin(tt,tt.val)] = yes ; 
tlast(t)$[t.val=smax(tt,tt.val)] = yes ; 

*--- Data ---
scalar 
    p  "sale price ($/tree)" /100/ 
    g  "annual growth rate for trees (%)" /1.021/
    s0 "initial stock of trees (trees)" /100/ 
    r  "discount rate (%)" /0.02/ 
; 
