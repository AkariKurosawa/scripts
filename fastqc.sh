#!/bin/bash

usage() {
  echo "Usage: ${0} [-h|--help] [-t|--threads] <INT> [-o|--output_dir] [-i|--fastq_dir]<string>" 1>&2
  exit 1 
}

ARGS=`getopt -o "ht:o:i:" --long "help,threads:,output_dir:,fastq_dir:" -n "getopt.sh"  -- "$@"`

if [ $? != 0 ] ; then usage; exit 1 ; fi
eval set -- "$ARGS"

threads=8
output_dir=fastqc

while true;do
	case "$1" in
	-h|--help) usage;exit 1;shift;;
	-t|--threads) threads=$2;shift 2;;
	-o|--output_dir) output_dir=$2;shift 2;;
	-i|--fastq_dir) fastq_dir=$2;shift 2;;
	--) shift ; break ;;
         *) echo "Internal error!" ; exit 1 ;;
	esac
done

if [ ! -d ${output_dir} ];then mkdir -p ${output_dir};fi

ls -p ${fastq_dir} | grep -v "/$" | xargs -I {} fastqc -o ./${output_dir} ./${fastq_dir}/{}
multiqc ${output_dir} 
mv multiqc_data ${output_dir}
mv multiqc_report.html ${output_dir}
