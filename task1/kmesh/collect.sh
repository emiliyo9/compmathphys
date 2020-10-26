#!/bin/bash

for (( i = 0; i < 7; i++ )); do
    j=$(echo $i"*2+1" | bc)
    p=$(grep 'P=' $j.out | grep -o '[0-9]*\.[0-9]*')
    t=$(grep 'CPU' $j.out | tail -n1 | sed -e 's/^[^0-9]*//' | sed -e 's/ CPU.*//')
    echo -e $j"\t"$p"\t"$t
done
