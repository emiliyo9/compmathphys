#!/bin/bash


ecutwfc=90
prev_ecutrho=180
for (( i = 2; i < 11; ++i )); do
    # setup input file for pw.x
    ecutrho=$( bc -l <<<"$ecutwfc*$i" )
    sedEcutrho="25s/$prev_ecutrho/$ecutrho/g"
    $(sed -i $sedEcutrho halite.in)
    prev_ecutrho=$ecutrho

    $(pw.x -input halite.in > halite.out)

    # get all needed info from output file
    pressure=$(grep "P\=" halite.out | grep -o "[^\ ]*$")
    time=$(grep "PWSCF" halite.out | grep -o "[^\ ]*s" | sed "3q;d")

    # print findings
    echo -e "$ecutwfc\t$ecutrho\t$pressure\t$time"
done
