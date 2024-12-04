#!/bin/bash

# Define input and output file paths
INPUT_FILE="cleaned_students_mental_health_survey.csv"
OUTPUT_FILE="outliers_removed.csv"
awk -F, 'NR==1 || ($1 >= 15 && $1 <= 60 && $4 >= 0 && $4 <= 4 && $5 >= 0 && $5 <= 5 && $6 >= 0 && $6 <= 5 && $7 >= 0 && $7 <= 5)' $INPUT_FILE > $OUTPUT_FILE

echo "Outliers removed. Output saved to $OUTPUT_FILE"
