#!/bin/sh
#
#
#PBS -N kmesh1
#PBS -o out_kmesh1.file
#PBS -e error_kmesh1.file
#PBS -l walltime=1:00:00
#PBS -l nodes=1:ppn=6
#PBS -m be -M emile.segers8@gmail.com
#
# change to directory you were working when submitting job
cd $PBS_O_WORKDIR
#load QE
module load QuantumESPRESSO/5.2.1-intel-2015b
#run QE command
mpirun -np $PBS_NP pw.x -input 1.in > 1.out
