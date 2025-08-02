#!/bin/bash -l
#SBATCH --partition=fast
#SBATCH --time=1:00:00
#SBATCH --ntasks-per-node=48
#SBATCH --nodes=1
#SBATCH --mem=147000M
#SBATCH --output=%j.out
#SBATCH --error=%j.err
#SBATCH --account=pl0251-02

module load gaussian/g16.C01

work_dir="${SCRATCH}/${SLURM_JOB_ID}"
mkdir -p "${work_dir}"

# Create links between working directories
ln -sf "/mnt/storage_2/project_data/pl0251-02/platins-heniek/cis/QM/aquation/products/MCPB" "${work_dir}/original_dir"
ln -sf "${work_dir}" "/mnt/storage_2/project_data/pl0251-02/platins-heniek/cis/QM/aquation/products/MCPB/work_dir"

# Copy input files to work directory
for file in "/mnt/storage_2/project_data/pl0251-02/platins-heniek/cis/QM/aquation/products/MCPB"/*.{gjf,chk}; do
    [ -f "${file}" ] && cp "${file}" "${work_dir}/"
done

# Change to work directory
cd "${work_dir}" || exit 1

# Run Gaussian
g16 "CIX_large_mk.gjf" 

formchk "CIX_large_mk.chk"

# Remove any temporary files if they exist
rm -f ./*.tmp 2>/dev/null

# Copy all output files back to the original directory
cp -r * "/mnt/storage_2/project_data/pl0251-02/platins-heniek/cis/QM/aquation/products/MCPB/"

# Cleanup
cd "/mnt/storage_2/project_data/pl0251-02/platins-heniek/cis/QM/aquation/products/MCPB" || exit 1
rm -rf "${work_dir}"
rm -rf "/mnt/storage_2/project_data/pl0251-02/platins-heniek/cis/QM/aquation/products/MCPB/work_dir"
rm -rf "/mnt/storage_2/project_data/pl0251-02/platins-heniek/cis/QM/aquation/products/MCPB/original_dir"

