gams franzi_start.gms --grate=0.01 --rrate=0.01
gams franzi_start.gms --grate=0.02 --rrate=0.01
gams franzi_start.gms --grate=0.03 --rrate=0.01
gams franzi_start.gms --grate=0.04 --rrate=0.01
gams franzi_start.gms --grate=0.05 --rrate=0.01
gams franzi_start.gms --grate=0.06 --rrate=0.01
gams franzi_start.gms --grate=0.07 --rrate=0.01
gams franzi_start.gms --grate=0.02 --rrate=0.01
gams franzi_start.gms --grate=0.02 --rrate=0.02
gams franzi_start.gms --grate=0.02 --rrate=0.03
gams franzi_start.gms --grate=0.02 --rrate=0.04
gams franzi_start.gms --grate=0.02 --rrate=0.05
gams franzi_start.gms --grate=0.02 --rrate=0.06
gams franzi_start.gms --grate=0.02 --rrate=0.07
gdxmerge franzi*.gdx
gdxdump merged.gdx format=csv symb=rep > rep.csv