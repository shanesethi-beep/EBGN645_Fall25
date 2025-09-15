gams ripleysrestaurant.gms --combo=1
gams ripleysrestaurant.gms --combo=0
gdxmerge *.gdx
gdxdump merged.gdx format=csv symb=profit > profit.csv