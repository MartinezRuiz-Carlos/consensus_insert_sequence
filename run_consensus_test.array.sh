#!/bin/bash
#SBATCH --job-name=consensus_sequence      # Job name
#SBATCH --ntasks=1                              # Run one tasks
#SBATCH --mem=16G                               # Job Memory
#SBATCH --time=4:00:00                          # Time limit hrs:min:sec
#SBATCH --output=tmp/logs/consensus_sequence_%A_%a.log     # Standard output and error log
#SBATCH --array=0-32                          #Number of tasks to run 
ml purge
module load MAFFT/7.505-GCC-11.3.0-with-extensions

# Generate TMP and OUT_DIRs if not yet present
TMP_DIR=tmp/03-005-0130_03-5994_nl
OUT_DIR=results/03-005-0130_03-5994_nl
mkdir -p ${TMP_DIR}
mkdir -p ${OUT_DIR}

# Generate an array of samples
SAMPLES_ARRAY=($(ls tmp/* | tr '\n' ' '))

# Divide the array into more manageable chunks
CHUNK_START=$((SLURM_ARRAY_TASK_ID * 1000))
CHUNK_END=$((CHUNK_START + 999))
ARRAY_CHUNK=(${SAMPLES_ARRAY[@]:${CHUNK_START}:${CHUNK_END}})

# Run through the fasta files in the chunk
for THIS_FILE in ${ARRAY_CHUNK[@]}; do
    INS_ID=$(echo ${THIS_FILE} | cut -d '.' -f 1)
    python consensus_insert_sequence.py -i ${TMP_DIR}/${THIS_FILE} -n ${INS_ID} -o ${OUT_DIR}
done

if [ $? -eq 0 ]; then
    echo "DONE"
fi