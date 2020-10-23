#!/bin/bash

ecutwfc=$(grep "twfc" config.in | grep -o "[0-9]*")
prev_ecutrho=$(grep "trho" config.in | grep -o "[0-9]*")
for (( i = 2; i < 11; ++i )); do
    # setup input file for pw.x
    ecutrho=$( echo "$ecutwfc*$i" | bc )
    sedEcutrho=$(grep -n "trho" config.in | grep -o "^[0-9]*")"s/$prev_ecutrho/$ecutrho/g"
    $(sed -i $sedEcutrho config.in)
    prev_ecutrho=$ecutrho

    ./run

    # get all needed info from output file
    pressure=$(grep "P\=" config.out | grep -o "[^\ ]*$")
    time=$(grep "PWSCF" config.out | grep "CPU" | grep -o "[^\ ]*\ \?[^\ ]*\ \?[^\ ]*s" | tail -n1)

    # print findings
    echo -e "$i\t$ecutwfc\t$ecutrho\t$pressure\t$time"
done

echo "What factor do you want to use? "
read f
ecutrho=$( echo "$ecutwfc*$f" | bc )
sedEcutrho=$(grep -n "trho" config.in | grep -o "^[0-9]*")"s/$prev_ecutrho/$ecutrho/g"
$(sed -i $sedEcutrho config.in)
