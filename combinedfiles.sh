#!/bin/bash

output_file="ALLRMSF.txt"
rm -f "$output_file"

plot_dir="/path/to/your/plots"  
output_file="ALLRMSF.txt"
mutants=(WT A97V S171L T180I M188I)  

for mut in "${mutants[@]}"
do
  echo "Processing mutant: $mut"

  
  input_file="$plot_dir/$mut-rmsf-CA.txt"

  
  if [ -d "$plot_dir" ]; then
    
    if [ -f "$input_file" ]; then
      awk -v val="$mut" '{
        if ($1 < 229) {
          print val",ChainA,"$1+1","$2          
        } else {
          print val",ChainB,"$1-228","$2
        }
      }' "$input_file" >> "$output_file"
    else
      echo "Input file not found: $input_file"
    fi
  else
    echo "Directory not found: $plot_dir"
  fi

done

echo "Processing complete. Results saved to $output_file"
