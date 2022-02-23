#!/bin/bash

set -uex
set -o pipefail

ids_file=
kls_index=
raw_dir=
trim_galore_dir=
fastqc_dir=
kls_dir=
kls_threads=8
reads= 

start_time=$(date +%s)

bash ~/resource/scripts/fq_dump.sh -n ${reads} -i ${ids_file} -o ${raw_dir}
bash ~/resource/scripts/trim_galore.sh -i ${raw_dir} -o ${trim_galore_dir} 
bash ~/resource/scripts/fastqc.sh -i ${trim_galore_dir} -o ${fastqc_dir}
bash ~/resource/scripts/kallisto_quant.sh -t ${kls_threads} ${kls_single_length} -s ${kls_single_sd} -b 100 -o ${kls_dir} -i ${kls_index} -f ${trim_galore_dir}
 
end_time=$(date +%s)
cost_time=$[ $end_time-$start_time ]
echo "${0}: time cost $(($cost_time/60))min $(($cost_time%60))s"

