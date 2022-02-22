#!/bin/bash

set -uex
set -o pipefail 

ids_file=
ht2_index=
gtf=
raw_dir=
trim_galore_dir=
fastqc_dir=
ht2_dir=
reads= 

bash ~/resource/scripts/fq_dump.sh -n ${reads} -i ${ids_file} -o ${raw_dir}
bash ~/resource/scripts/trim_galore.sh -i ${raw_dir} -o ${trim_galore_dir} 
bash ~/resource/scripts/fastqc.sh -i ${trim_galore_dir} -o ${fastqc_dir}
bash ~/resource/scripts/hisat2_stringtie.sh -t 8 --paired -o ${ht2_dir} -i ${ht2_index} -g ${gtf} -f ${trim_galore_dir}
 
