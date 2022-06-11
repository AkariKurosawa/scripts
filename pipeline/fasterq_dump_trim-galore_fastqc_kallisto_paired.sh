#!/bin/bash

set -uex
set -o pipefail

ids_file=
fasterq_dump_threads=8
kls_index=
raw_dir=
trim_galore_dir=
fastqc_dir=
kls_dir=
kls_threads=8

start_time=$(date +%s)

bash ~/resource/scripts/fasterq_dump.sh -e ${fasterq_dump_threads} -i ${ids_file} -o ${raw_dir} -g
bash ~/resource/scripts/trim_galore.sh -i ${raw_dir} -o ${trim_galore_dir} -g -p
bash ~/resource/scripts/fastqc.sh -i ${trim_galore_dir} -o ${fastqc_dir}
bash ~/resource/scripts/kallisto_quant.sh -t ${kls_threads} -b 100 -o ${kls_dir} -i ${kls_index} -f ${trim_galore_dir}
 
end_time=$(date +%s)
cost_time=$[ $end_time-$start_time ]
echo "${0}: time cost $(($cost_time/60))min $(($cost_time%60))s"

