
set i /coal, gas, wind/,  
    r /r1, r2/,
    h /1*24/ ; 

alias(r,rr) ; 
alias(h,hh) ; 

* have normally had simple examples like this...
parameter c(i)
/
Coal	20
Gas	15
Wind	1
/ ;

set vre(i) /wind/ ; 