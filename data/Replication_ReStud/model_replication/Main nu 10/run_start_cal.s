#!/bin/bash

#SBATCH --job-name=Run_start_hpc
#SBATCH --nodes=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=8GB
#SBATCH --time=167:00:00
#SBATCH --mail-type=END
#SBATCH --mail-user=fkg210@nyu.edu

module purge
module load matlab/2018b

#### start MATLAB, everything between EOF's is ran in Matlab
#########################################################################
cat<<EOF | srun matlab -nodisplay

warning off MATLAB:maxNumCompThreads:Deprecated
maxNumCompThreads($SLURM_CPUS_PER_TASK);

addpath(genpath('/home/fkg210/CompEcon'));

clear;
close all;
clc;

start_calibration

exit
EOF
#########################################################################

