#!/bin/sh
#
#
#PBS -N phonon_calc
#PBS -o out.file
#PBS -e err.file
#PBS -l walltime=48:00:00
#PBS -l nodes=1:ppn=24
#PBS -m be -M emile.segers8@gmail.com
#
# change to directory you were working when submitting job
cd $PBS_O_WORKDIR
#load QE
module load QuantumESPRESSO/6.5-intel-2019b
#run QE command
mpirun -np $PBS_NP pw.x -input X5P2/300.in > X5P2/300.out
mpirun -np $PBS_NP pw.x -input X5P2/0.in > X5P2/0.out
mpirun -np $PBS_NP pw.x -input X5C1/300.in > X5C1/300.out
mpirun -np $PBS_NP pw.x -input X5C1/0.in > X5C1/0.out
