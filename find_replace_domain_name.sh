#!/bin/bash

# Define the folder containing the files
folder="./public"

# Define the word to be replaced
old_word="https://antonidag.github.io"

# Define the new word
new_word="https://antonbjorkman.com"

# Use find to recursively search for files in the folder and replace the word
find "$folder" -type f -exec sed -i "s|$old_word|$new_word|g" {} +

echo "Replaced \"$old_word\" with \"$new_word\" in all files within $folder and its subfolders."
