#!/bin/bash

# Define input and output file paths
INPUT_FILE="students_mental_health_survey.csv"
OUTPUT_FILE="cleaned_students_mental_health_survey.csv"

# Check if the input file exists
if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: Input file not found!"
    exit 1
fi

# Step 1: Remove rows with more than 50% missing values
awk -F, '
BEGIN { OFS = FS }
NR == 1 { print; next } # Keep the header
{
    missing = 0
    for (i = 1; i <= NF; i++) {
        if ($i == "" || $i == "NA") missing++
    }
    if (missing < NF / 2) print
}' "$INPUT_FILE" > temp.csv

# Step 2: Use Python to handle missing values and clean the data
python3 - <<EOF
import pandas as pd

# Load the dataset
data = pd.read_csv("temp.csv")

# Fill missing numeric values with column mean
for col in data.select_dtypes(include=["float64", "int64"]).columns:
    data[col].fillna(data[col].mean(), inplace=True)

# Fill missing categorical values with the mode
for col in data.select_dtypes(include=["object"]).columns:
    data[col].fillna(data[col].mode()[0], inplace=True)

# Remove duplicate rows
data = data.drop_duplicates()

# Save the cleaned dataset
data.to_csv("$OUTPUT_FILE", index=False)
EOF

# Step 3: Clean up intermediate files
rm temp.csv

echo "Data cleaning complete. Cleaned file saved as $OUTPUT_FILE"

