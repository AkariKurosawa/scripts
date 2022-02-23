#!/bin/bash

set -uex
set -o pipefail

esearch -db sra -query ${1} | efetch -format runinfo > runinfo.csv
cat runinfo.csv | cut -f 1 -d , | grep SRR >> runids.txt

