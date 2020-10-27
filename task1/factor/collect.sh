#!/bin/bash

for (( i = 2; i < 11; i++ )); do
    w=$(grep "ecutwfc" $i.in | grep -o '[0-9]*')
    r=$(grep "ecutrho" $i.in | grep -o '[0-9]*')
    f=$(echo $r"/"$w | bc)
    p=$(grep 'P=' $i.out | grep -o '[0-9]*\.[0-9]*')
    t=$(grep 'CPU' $i.out | tail -n1 | sed -e 's/^[^0-9]*//' | sed -e 's/ CPU.*//')
    echo -e $f"\t"$w"\t"$r"\t"$p"\t"$t
done
