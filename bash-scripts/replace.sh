#!/bin/bash

grep -i "cn=" ldif | awk -F"cn=" '{print $2}' | cut -d ',' -f 1 > cn

word1=($(cat cn))
word2=($(cat cn-new))

for i in "${!word1[@]}"; do
        echo "sed -i 's|${word1[i]}\>|${word2[i]}|g' ldif"
done
