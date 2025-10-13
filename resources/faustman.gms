* Faustmann Model in GAMS

* create a species type
set s species /oak, maple/ ; 

$if not set rate $setglobal rate 10

* scalar are non-indexed parameters
scalar r  discount rate / %rate% /;
r = r/100 ; 

* set up parameters by species
parameter p(s)  timber price / oak 1000, maple 2000 /,
          c(s)  replanting cost / oak 500, maple 1000 /,
          f(s) growth_rate / oak 0.08, maple 0.06 /, 
          init_stock(s) /oak 100, maple 50/ ; 

* objective function always needs to be a free variable (positive or negative)
variable Z present_value;

* standard for the remaining variables to be positive
positive variable T(s) rotation_period by species;

* Equations
equation objective;

* Model
objective.. Z=e= 
    sum(s,p(s) * (init_stock(s) * (1+f(s))**T(s) - c(s)) / (exp(r*T(s)) - 1) );

* declare equation to use the model
* alternatively, could be '/all/' ; 
model faustmann / objective/;

* set a lower bound to avoid weird objective function values
* this also helps to specify a starting point for the model that isn't zero
t.lo(s) = 1 ; 

* solve the model using non-linear programming (NLP) 
* while specifying the direction of the objective
solve faustmann using nlp maximizing Z ; 

* record the level (.l) value of the optimal harvest value
* round this to an integer value
parameter tstar ; 
tstar("%rate%",s) = round(T.l(s),0) ; 

* year set for recording purposes
set y year /0*100/ ; 

* reporting parameters to compute how many have passed since harvest in year 'y'
* as well as the stock at any year 'y'
parameter years_since_harvest, stock ; 
* here the years since harvest are the remainder (mod) of the year value and
* the optimal rotation period
years_since_harvest("%rate%",s,y) = mod(y.val,tstar("%rate%",s)) ; 

* compute the stock
stock("%rate%",s,y) = init_stock(s) * (1+f(s)) ** years_since_harvest("%rate%",s,y) ; 

* this will dump everything to a gdx file that you can load into the GAMS studio
* app - you can dump data to CSV via something simple from the command prompt like:
* 'gdxdump faustmann.gdx format=csv symb=stock > stock_jw.csv'
execute_unload 'faustmann_%rate%.gdx' ; 