#!/bin/bash

elements=($(grep "_formula" $1 | grep -o "'.*'" | grep -o "[a-zA-Z]*"))

python3 prepare_qe.py $1 config

mwf=0
mdf=0

for element in ${elements[@]}; do
    f="pseudo/"$element"_PSEUDO"
    wget -O "pseudo/"$element"_PSEUDO" "http://www.quantum-espresso.org/pseudopotentials/ps-library/$(echo "${element,,}")"
    echo $(grep "UPF" $f | grep -o "<[^>]*" | head -n1 | grep -o '"[^"]*"$' | sed 's/"//')
    wget -O "pseudo/"$element"_PSEUDO" "http://www.quantum-espresso.org$(grep "UPF" $f | grep -o "<[^>]*" | head -n1 | grep -o '"[^"]*"$' | tr -d '"')"
    wf=$(grep "wavefunctions" $f | grep -o "[0-9]*")
    if [[ $wf > $mwf ]]; then
        mwf=$wf
    fi
    df=$(grep "charge density" $f | grep -o "[0-9]*")
    if [[ $df > $mdf ]]; then
        mdf=$df
    fi
done

sedCommand=$(grep -n "twfc" config.in | grep -o "^[0-9]*")"s/50/"$mwf"/"
$(sed -i $sedCommand config.in)
sedCommand=$(grep -n "trho" config.in | grep -o "^[0-9]*")"s/200/"$mdf"/"
$(sed -i $sedCommand config.in)

./auto_K_mesh.sh
