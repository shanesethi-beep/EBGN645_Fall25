* assume k is 3500

set stock /0*3500/ ; 

scalar r /0.5/ ;
scalar k /3500/ ;  

parameter DsDt ; 
DsDt(stock) = r * stock.val * (1 - stock.val / k)

set t /0*49/ ; 
set tfirst(t) /0/ ; 


parameter stock_size(t) ; 
stock_size(t) = 0 ;

scalar stock_init /0.05/ ; 

loop(t,
stock_size(t) = stock_init$tfirst(t) 
                + stock_size(t-1)
                + r * stock_size(t-1) * (1-stock_size(t-1)/k) ;
) ; 

parameter stock_growth(t) ; 

stock_growth(t) = stock_size(t) - stock_size(t-1) ; 

set a "alpha values" /10, 15/ ;
parameter alpha(a) ; 
alpha(a) = a.val / 1e4 ; 

parameter sustainable_effort(stock,a) ;
sustainable_effort(stock,a)$(stock.val) = (r * stock.val * (1-stock.val/k))
                        / (alpha(a) * stock.val) ;

scalar price /10/, cost /5/ ; 

parameter TRTC ; 
TRTC("TR",stock,a) = DsDt(stock) * price ; 
TRTC("TC",stock,a) = sustainable_effort(stock,a) * cost ; 
TRTC("PROFIT",stock,a) = TRTC("TR",stock,a) - TRTC("TC",stock,a) ; 
TRTC("ABSDiff",stock,a) = abs(TRTC("TR",stock,a) - TRTC("TC",stock,a)) ; 

parameter opt_stocks ; 
alias(stock,stock2) ; 
opt_stocks("PC",stock,a)$[TRTC("ABSDiff",stock,a) = smin(stock2,TRTC("ABSDiff",stock2,a))] = stock.val ; 
opt_stocks("SOC",stock,a)$[TRTC("profit",stock,a) = smax(stock2,TRTC("PROFIT",stock2,a))] = stock.val ; 


execute_unload 'fishies.gdx' ; 

