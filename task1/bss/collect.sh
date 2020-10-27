#!/bin/bash

for (( i = 1; i < 21; i++ )); do
    w=$(grep "ecutwfc" $i.in | grep -o '[0-9]*')
    r=$(grep "ecutrho" $i.in | grep -o '[0-9]*')
    p=$(grep 'P=' $i.out | grep -o '[0-9]*\.[0-9]*')
    t=$(grep 'CPU' $i.out | tail -n1 | sed -e 's/^[^0-9]*//' | sed -e 's/ CPU.*//')
    echo -e $w"\t"$r"\t"$p"\t"$t
done
