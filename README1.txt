README: RMSF Plot Generation and Analysis

This README provides an overview of the provided script and guidance on customizing it for generating RMSF (Root Mean Square Fluctuation) plots from molecular dynamics simulation data. The script processes RMSF data for various mutants and generates publication-quality plots using R and bash.

Files Included

R Script (RMSF_plot.R)

Processes and filters RMSF data.

Generates detailed plots with facets for ligands and domains.

Bash Script (process_rmsf.sh)

Automates the processing of RMSF data for multiple mutants.

Outputs the formatted data into ALLRMSF.txt for use in the R script.

How It Works

The bash script reads RMSF data files for specific mutants, processes the data, and appends it to a single output file (ALLRMSF.txt).

The R script reads ALLRMSF.txt, applies filtering, and generates RMSF plots grouped by protein, ligand, and domain.

Customization

1. Bash Script Modifications

Directory Path: Update the plot_dir variable to the directory containing your RMSF data files.

plot_dir="/path/to/your/plots"  # Change this to your data directory

Mutants List: Modify the mutants array to include the mutants you want to process.

mutants=(WT A97V S171L T180I M188I)  # Add or remove mutants as needed

Input File Naming: Ensure the input files follow the format mutant-rmsf-CA.txt or update the input_file variable construction in the script.

2. R Script Modifications

File Path: Ensure the ALLRMSF.txt file is in the working directory or adjust the file path in the R script.

x <- read.table("ALLRMSF.txt", header = FALSE, sep = ',')

Plot Aesthetics: Customize color schemes, axis labels, or themes by modifying the ggplot code.

Residue Annotations: Add or modify residue-specific annotations by updating the dfa and dfb vectors.

dfa <- c(75, 81)  # Add new annotations as needed
dfb <- c(97, 171, 180, 188)

Output

The bash script outputs a single file, ALLRMSF.txt, containing formatted RMSF data.

The R script generates a plot (all_filtered2.png) with separate facets for ligands and domains.

Notes

Ensure that all required libraries (e.g., ggplot2, dplyr) are installed in R before running the script.

Both scripts assume specific input file formats. Adjust the scripts if your data format differs.