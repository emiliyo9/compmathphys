#!/bin/bash


prev_ecutwfc=16
prev_ecutrho=80
for (( i = 1; i < 21; ++i )); do
    # setup input file for pw.x
    ecutwfc=$( bc -l <<<"10*$i+6" )
    ecutrho=$( bc -l <<<"$ecutwfc*5" )
    if [[ i -eq 20 ]]; then
        ecutwfc=200
        ecutrho=800
    fi
    sedEcutwfc="24s/$prev_ecutwfc/$ecutwfc/g"
    sedEcutrho="25s/$prev_ecutrho/$ecutrho/g"
    $(sed -i $sedEcutwfc halite.in)
    $(sed -i $sedEcutrho halite.in)
    prev_ecutwfc=$ecutwfc
    prev_ecutrho=$ecutrho

    $(pw.x -input halite.in > halite.out)

    # get all needed info from output file
    pressure=$(grep "P\=" halite.out | grep -o "[^\ ]*$")
    time=$(grep "PWSCF" halite.out | grep -o "[^\ ]*s" | sed "3q;d")

    # print findings
    echo -e "$ecutwfc\t$ecutrho\t$pressure\t$time"
done
