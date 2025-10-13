
set 
i "machines"    /X1, X2/,
j "jelly beans" /Yellow, Blue, Green, Orange, Purple/, 
v(i,j) "valid combinations of machines and jelly beans" ; 

alias(j,jj) ; 

* any machine can produce any type of jelly bean
v(i,j) = yes ; 

* we'll add this on later
set v_restricted(i,j)
/
X1.(yellow,blue,green),
X2.(yellow,orange,purple)
/ ;


scalar 
    sw_maxdev "switch to enable maximum deviation constraints" /0/ 
    hbar "total hours in a week" /40/ 
    h "production rate (jellybeans per hour)" /100/
    delta "maximum deviation across total weekly production" /0.05/
;

parameter r(j) "net revenue ($ / jellybean)"
/
Yellow  1
Blue    1.05
Green   1.07
Orange  0.95
Purple  0.9
/;


positive variables X(i,j) "jellybeans of type j produced by machine i" ;
variables Z "profit - the target of our optimization" ; 

equation 
eq_objfn
eq_hourlimit(i)
eq_maxdev_upper(j,jj)
eq_maxdev_lower(j,jj) 
;

eq_objfn.. Z =e= sum((i,j)$v(i,j), r(j) * X(i,j)) ;

eq_hourlimit(i).. hbar * h =g= sum(j$v(i,j),X(i,j)) ; 

eq_maxdev_upper(j,jj)$[sw_maxdev$(not sameas(j,jj))].. 
    sum(i$v(i,j),X(i,j)) =g= (1-delta) * sum(i$v(i,jj),X(i,jj)) ;  

eq_maxdev_lower(j,jj)$[sw_maxdev$(not sameas(j,jj))].. 
    (1+delta) * sum(i$v(i,jj),X(i,jj)) =g= sum(i$v(i,j),X(i,j)) ;  

parameter report ; 

model june /all/ ; 
sw_maxdev = 0 ; 
solve june using lp maximizing Z ; 
report("case",i,j) = x.l(i,j) ; 
report("case","profit","profit") = z.l ; 

sw_maxdev = 1 ; 
solve june using lp maximizing Z ; 
report("maxdev",i,j) = x.l(i,j) ; 
report("maxdev","profit","profit") = z.l ; 

* disable all combinations of machines and jellybeans
v(i,j) = no ; 
* enable only those combinations in v_restricted
sw_maxdev = 0 ; 
v(i,j)$v_restricted(i,j) = yes ; 
solve june using lp maximizing Z ; 
report("machinerestrict",i,j) = x.l(i,j) ; 
report("machinerestrict","profit","profit") = z.l ; 

* fully restricted model
* both maximum deviation restriction
* and machine-jellybean restriction
sw_maxdev = 1 ;
solve june using lp maximizing Z ; 
report("both",i,j) = x.l(i,j) ; 
report("both","profit","profit") = z.l ; 


execute_unload 'junebug.gdx' ; 