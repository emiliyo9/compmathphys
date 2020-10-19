#!/bin/bash

factor=$(echo "$2 / $1" | bc)
prev_ecutwfc=$1
prev_ecutrho=$2
for (( i = 1; i < 21; ++i )); do
    # setup input file for pw.x
    ecutwfc=$( echo $prev_ecutwfc"/5+10" | bc )
    ecutrho=$( echo "$ecutwfc*$factor" | bc )

    sedEcutwfc=$(grep -n "twfc" config.in | grep -o "^[0-9]*")"s/$prev_ecutwfc/$ecutwfc/g"
    sedEcutrho=$(grep -n "trho" config.in | grep -o "^[0-9]*")"s/$prev_ecutrho/$ecutrho/g"
    $(sed -i $sedEcutwfc config.in)
    $(sed -i $sedEcutrho config.in)
    prev_ecutwfc=$ecutwfc
    prev_ecutrho=$ecutrho

    ./run

    # get all needed info from output file
    pressure=$(grep "P\=" config.out | grep -o "[^\ ]*$")
    time=$(grep "PWSCF" config.out | grep "CPU" | grep -o "[^\ ]*s" | sed "3q;d")

    # print findings
    echo -e "$ecutwfc\t$ecutrho\t$pressure\t$time"
done

echo "What basis set size do you want to use? (Just the value for the wave function is needed)"
read b
sedEcutwfc=$(grep -n "twfc" config.in | grep -o "^[0-9]*")"s/$prev_ecutwfc/$b/g"
ecutrho=$( echo "$b*$factor" | bc )
sedEcutrho=$(grep -n "trho" config.in | grep -o "^[0-9]*")"s/$prev_ecutrho/$ecutrho/g"
$(sed -i $sedEcutwfc config.in)
$(sed -i $sedEcutrho config.in)
