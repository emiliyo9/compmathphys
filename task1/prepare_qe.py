# Created by Emile Segers <emile.segers@ugent.be>
#
# This is based on a script based on a scripted made by Wouter Heyvaert
#
# Use this file to prepare a project directory
# for Quantum Espresso for a given cif file.
#
# Usage: Move this file to a directory where you
# want to create your project files. Put your cif
# file in the same directory and run the following
# line in your terminal:
#   $ python3 prepare_qe.py <cif-file> <project-name>
# where <cif-file> is the name+extension of your
# cif file and <project-name> is the name (without
# extension) that you .in file will get.
#
# This script will create an output directory
# "output" and a directory "pseudo" where you put
# your pseudo potential files. This will also create
# a starting template for your .in file, but you
# have to check it and adjust it to your needs
# afterwards. Finally this script will also create
# a file named "run". This will start QE, such that
# you don't have to type the whole command everytime.
# This can be run by entering "./run" in your terminal.
import sys
import os

# Get arguments
if len(sys.argv) < 3:
    print('Usage:\n$ python3 prepare.py <cif-file> <target-name>')
    exit(1)

cif_name = sys.argv[1]
name = sys.argv[2]
print(f'Creating project "{name}" based on "{cif_name}"...')

# Create directories
if not os.path.exists('output'):
    os.makedirs('output')
if not os.path.exists('pseudo'):
    os.makedirs('pseudo')

if os.path.exists(f'{name}.in'):
    os.remove(f'{name}.in')

# Run cif2cell
print('Running cif2cell...')
os.system(f'cif2cell -f {cif_name} -o {name}.in -p quantum-espresso')

# Add standard options
print('Adding defaults to input file...')
with open(f'{name}.in', 'r') as f:
    contents = f.readlines()

## Look for line with SYSTEM
## Insert control configs
line=0
while "SYSTEM" not in contents[line]:
    line+=1

contents.insert(line, f"""\
&CONTROL
  calculation = 'scf'
  outdir = 'output'
  prefix = '{name}'
  pseudo_dir = 'pseudo'
  verbosity = 'low'
  tprnfor = .true.
  tstress = .true.
/
""")

## Look for end of system config
## Add to system config and electron config
line+=1
while "/" not in contents[line]:
    line+=1

contents.insert(line, f"""\
  ecutwfc = 50
  ecutrho = 200
  input_dft = 'pbe'
  occupations = 'smearing'
  smearing = 'mv'
  degauss = 0.005d0
  nspin = 2
  starting_magnetization(1) = 0.5
  starting_magnetization(2) = -0.01
/
&ELECTRONS
  conv_thr = 1d-08
  mixing_beta = 0.7d0
""")

contents.append("""\
K_POINTS {automatic}
  1 1 1 0 0 0

""")

with open(f'{name}.in', 'w') as f:
    f.writelines(contents)

# Create executable
print('Creating executable file (./run)...')
run = f'#!/bin/bash\npw.x -input {name}.in > {name}.out'
with open('run', 'w') as f:
    f.writelines(run)
os.system('chmod +x run')

print('Done.')
print(f'Please put your pseudopotentials in "./pseudo"\nand adjust "{name}.in" to your needs.')
