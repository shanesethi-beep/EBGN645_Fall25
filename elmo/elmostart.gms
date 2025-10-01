
set i /coal, gas, wind/,  
    r /r1, r2/,
    h /1*24/ ; 

alias(r,rr) ; 
alias(h,hh) ; 
alias(i,ii) ; 


* have normally had simple examples like this...
parameter c(i)
/
Coal	20
Gas	15
Wind	1
/ ;

set vre(i) /wind/ ; 

table capacity(i,r)
$ondelim
$include capacity.csv
$offdelim 
;

table demand(h,r)
$ondelim
$include demand.csv
$offdelim 
;

parameter cf_wind(h)
$include wind.txt
;

cf_wind("18") = 5 * cf_wind("18") ; 

positive variable g(i,r,h) 'generation by hour' ; 
variable z 'objective function target' ;

equations objfn, capacitylimit, eq_demand ; 


objfn.. z =e= sum((i,r,h), g(i,r,h) * c(i)) ;

capacitylimit(i,r,h).. (1$[not vre(i)] + cf_wind(h)$vre(i)) * capacity(i,r) =g= g(i,r,h) ; 

eq_demand(r,h).. sum(i,g(i,r,h))  =g= demand(h,r) ; 

model elmo /all/ ;
solve elmo using lp minimizing z ; 
execute_unload 'alldata.gdx' ; 

