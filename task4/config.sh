#!/bin/sh
#
#
#PBS -N phonon_calc_2gpa
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
mpirun -np $PBS_NP pw.x -input X1P5/x1p5_2gpa.in > X1P5/x1p5_2gpa.out
