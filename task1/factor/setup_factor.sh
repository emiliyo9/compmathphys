#!/bin/bash

w=$(grep 'twfc' config.in | grep -o '[0-9]*')
r=$(grep 'trho' config.in | grep -o '[0-9]*')
for (( i = 2; i < 21; ++i )); do
    # setup input file for pw.x
    
    $(cp config.in $i.in)
    sedEcutrho=$(grep -n "trho" $i.in | grep -o "^[0-9]*")"s/$r/"$(echo $w"*"$i | bc)"/g"
    echo $sedEcutrho
    $(sed -i $sedEcutrho $i.in)
    
    $(cp config.sh $i.sh)
    $(sed -i "4,6s/1/$i/g" $i.sh)
    $(sed -i "16s/1/$i/g" $i.sh)

done
