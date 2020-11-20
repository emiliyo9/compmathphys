#!/bin/sh
#
#
#PBS -N phonon_calc
#PBS -o out.file
#PBS -e err.file
#PBS -l walltime=24:00:00
#PBS -l nodes=1:ppn=24
#PBS -m be -M emile.segers8@gmail.com
#
# change to directory you were working when submitting job
cd $PBS_O_WORKDIR
#load QE
module load QuantumESPRESSO/5.2.1-intel-2015b
#run QE command
mpirun -np $PBS_NP pw.x -input X1P5/config.in > X1P5/config.out
