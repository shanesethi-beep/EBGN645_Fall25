declare -a arr=("0.03" "0.05" "0.07")
 
## loop through the above array
for i in "${arr[@]}"
do
#   echo "$i"
   gams hotel_comp.gms --rate=$i
done

gdxmerge hotel*.gdx
gdxdump merged.gdx format=csv symb=rep > hotel_rep.csv