#!/bin/bash

prev=11
for k in 1 3 5 7 9 11
do
    # setup input file for pw.x
    sedCommand="46s/$prev/$k/g"
    $(sed -i $sedCommand halite.in)
    kval=$(sed '$q;d' halite.in)
    prev=$k

    $(pw.x -input halite.in > halite.out)

    # get all needed info from output file
    pressure=$(grep "P\=" halite.out | grep -o '[^\ ]*$')
    time=$(grep "PWSCF" halite.out | grep -o "[^\ ]*s" | sed "3q;d")

    # print findings
    echo -e "$k\t$pressure\t$time"
done
