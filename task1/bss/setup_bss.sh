#!/bin/bash

factor=$(echo "$2 / $1" | bc)
prev_ecutwfc=$1
prev_ecutrho=$2
ecutwfc=$(echo $prev_ecutwfc"/10-1" | bc)
ecutwfc=$(echo $ecutwfc"*10" | bc)
ecutrho=$(echo "$ecutwfc*$factor" |bc)
for (( i = 1; i < 21; ++i )); do
    # setup input file for pw.x
    
    $(cp config.in $i.in)
    sedEcutwfc=$(grep -n "twfc" $i.in | grep -o "^[0-9]*")"s/$1/$ecutwfc/g"
    sedEcutrho=$(grep -n "trho" $i.in | grep -o "^[0-9]*")"s/$2/$ecutrho/g"
    echo $sedEcutrho
    $(sed -i $sedEcutwfc $i.in)
    $(sed -i $sedEcutrho $i.in)
    prev_ecutwfc=$ecutwfc
    prev_ecutrho=$ecutrho
    
    ecutwfc=$( echo $prev_ecutwfc"+10" | bc )
    ecutrho=$( echo "$ecutwfc*$factor" | bc )

    $(cp config.sh $i.sh)
    $(sed -i "4,6s/1/$i/g" $i.sh)
    $(sed -i "16s/1/$i/g" $i.sh)

done
