#!/bin/bash


ecutwfc=90
prev_ecutrho=180
for (( i = 2; i < 11; ++i )); do
    # setup input file for pw.x
    ecutrho=$( bc -l <<<"$ecutwfc*$i" )
    sedEcutrho="25s/$prev_ecutrho/$ecutrho/g"
    $(sed -i $sedEcutrho config.in)
    prev_ecutrho=$ecutrho

    ./run

    # get all needed info from output file
    pressure=$(grep "P\=" config.out | grep -o "[^\ ]*$")
    time=$(grep "PWSCF" config.out | grep -o "[^\ ]*s" | sed "3q;d")

    # print findings
    echo -e "$ecutwfc\t$ecutrho\t$pressure\t$time"
done
