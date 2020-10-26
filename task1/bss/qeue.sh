#!/bin/sh

for (( i = 1; i < 21; i++ )); do
    qsub $i.sh
done
