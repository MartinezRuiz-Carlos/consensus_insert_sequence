#!/bin/bash
#SBATCH --job-name=index_mismatches             # Job name
#SBATCH --ntasks=1                              # Run one tasks
#SBATCH --mem=16G                               # Job Memory
#SBATCH --time=1:00:00                          # Time limit hrs:min:sec
#SBATCH --output=tmp/logs/index_mismatches_%A_%a.log     # Standard output and error log
#SBATCH --array=0-9                          #Number of tasks to run 
ml purge
module load MAFFT/7.505-GCC-11.3.0-with-extensions

SAMPLES_ARRAY=($(ls tmp/* | head -n10 | tr '\n' ' '))
THIS_FILE=${SAMPLES_ARRAY[${SLURM_ARRAY_TASK_ID}]}
INS_ID=$(echo ${THIS_FILE} | cut -d '.' -f 1)
TMP_DIR=tmp/03-005-0130_03-5994_nl


OUT_DIR=results/03-005-0130_03-5994_nl
mkdir -p ${OUT_DIR}

python consensus_insert_sequence.py -i ${TMP_DIR}/${THIS_FILE} -n ${INS_ID} -o ${OUT_DIR}