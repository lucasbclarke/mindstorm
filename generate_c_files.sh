#!/bin/bash

echo "Generating C files from yupp source files..."

# Generate C files from yu-c files
cd ev3dev-c/source/ev3
for file in *.yu-c; do
    echo "Processing $file"
    python ../../yupp/yup.py -q --pp-browse -d . "$file"
done

# Generate header files from yu-h files
for file in *.yu-h; do
    echo "Processing $file"
    python ../../yupp/yup.py -q --pp-browse -d . "$file"
done

echo "C file generation complete!" 