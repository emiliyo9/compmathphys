#!/bin/bash

echo "\nFinding solutions for different K meches\n\n"

prev=1
line=$(cat config.in | wc -l)
line=$(echo "$line-1" | bc)
#for k in 1 3 5 7 9 11
for k in 1 3
do
    # setup input file for pw.x
    sedCommand=$line"s/$prev/$k/g"
    $(sed -i $sedCommand config.in)
    kval=$(sed '$q;d' config.in)
    prev=$k

    ./run

    # get all needed info from output file
    pressure=$(grep "P\=" config.out | grep -o '[^\ ]*$')
    time=$(grep "PWSCF" config.out | grep -o "[^\ ]*s" | sed "3q;d")

    # print findings
    echo -e "$k\t$pressure\t$time"
done

echo "What K mech do you want to use? "
read k
sedCommand=$line"s/$prev/$k/g"
$(sed -i $sedCommand config.in)
