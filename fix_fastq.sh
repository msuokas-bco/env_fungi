
#!/bin/bash

# Fix empty sequences in FASTQ files only if necessary
# Usage: ./fix_fastq_batch.sh /path/to/fastq/files

input_dir="${1:-.}"  # Default to current directory if no path is provided
manifest_file="$input_dir/manifest.csv"

echo "Processing FASTQ files in: $input_dir"

# Prepare the QIIME2 manifest file
echo "sample-id,absolute-filepath,direction" > "$manifest_file"

# Loop through all *.fastq.gz files in the directory
for input_file in "$input_dir"/*.fastq.gz; do
    [[ -f "$input_file" ]] || continue  # Skip if no FASTQ files are found

    # Extract sample ID (text before the first underscore "_")
    filename=$(basename "$input_file")
    sample_id="${filename%%_*}"

    # Define fixed output filename
    output_file="${input_file%.fastq.gz}_fixed.fastq.gz"
    log_file="${output_file%.gz}.log"

    # Check if the file has orphaned headers
    bad_lines=$(zcat "$input_file" | awk '(NR-1)%4==0 && getline && $0=="" {print NR-1}' | wc -l)

    if [[ "$bad_lines" -gt 0 ]]; then
        echo "⚠️  Fixing: $input_file (Found $bad_lines empty sequences)"
        
        # Clear previous log file
        echo "Removed headers from $input_file" > "$log_file"

        # Process FASTQ file and remove orphaned headers
        zcat "$input_file" | awk -v logf="$log_file" '
        (NR-1) % 4 == 0 { 
            h = $0;
            getline; s = $0;
            getline; p = $0;
            getline; q = $0;
            if (s != "" && q != "") 
                print h "\n" s "\n" p "\n" q;
            else 
                print h >> logf;
        }' | gzip > "$output_file"

        # Use fixed file in manifest
        abs_path=$(realpath "$output_file")
    else
        echo "✅ No fixes needed: $input_file"
        abs_path=$(realpath "$input_file")  # Use original file in manifest
    fi

    # Add to QIIME2 manifest
    echo "$sample_id,$abs_path,forward" >> "$manifest_file"
done

echo "📄 QIIME2 manifest file created: $manifest_file"
echo "🎉 Processing complete!"
