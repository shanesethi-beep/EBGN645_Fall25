gams faustman.gms --rate=10
gams faustman.gms --rate=15
gams faustman.gms --rate=25

gdxmerge faustmann_*.gdx
gdxdump merged.gdx format=csv symb=stock > faustman_stock.csv

