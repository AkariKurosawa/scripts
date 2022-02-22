#!/bin/bash

usage() {
  echo "Usage: ${0} [-h|--help] [-t|--threads] <INT> [--single] [---paired] [-o|--output_dir] <string> [-i|--index] <string> [-g|--gtf] <STRING> [-f|--fastq_dir]<string>" 1>&2
  exit 1 
}

ARGS=`getopt -o "ht:o:i:g:f:" --long "help,threads:,single,paired,output_dir:,index:,gtf:,fastq_dir:" -n "getopt.sh"  -- "$@"`

if [ $? != 0 ] ; then usage; exit 1 ; fi
eval set -- "$ARGS"

threads=8
single=1
paired=0
output_dir=hisat2

while true;do
	case "$1" in
		-h|--help) usage;exit 1;shift 2;;
		-t|--threads) threads=$2 ; shift 2 ;;
		--single) single=1;shift;;
		--paired) single=0;paired=1;shift;;
		-o|--output_dir) output_dir=$2;shift 2;;
		-i|--index) index=$2;shift 2;;
		-g|--gtf) gtf=$2;shift 2;;
		-f|--fastq_dir) fastq_dir=$2; shift 2;;
                --) shift ; break ;;
                *) echo "Internal error!" ; exit 1 ;;
        esac
done

string1="hisat2  -p ${threads} -x ${index}"

if [ ! -d ${output_dir} ];then mkdir -p ${output_dir};fi

if [[ ${single} -eq 1 ]] && [[ ${paired} -eq 0 ]];then
for file in `ls ${fastq_dir}/*.fastq*`;do id=${file##*/};id=${id%%_*};mkdir ${output_dir}/${id};${string1} -U ${file} -S ${output_dir}/${id}/${id}.sam;done
elif [[ ${single} -eq 0 ]] && [[ ${paired} -eq 1 ]];then
for file in `ls ${fastq_dir}/*_1.fastq*`;do id=${file##*/};id=${id%%_*};mkdir ${output_dir}/${id};${string1} -1 ${file} -2 ${file/_1.fastq/_2.fastq}  -S ${output_dir}/${id}/${id}.sam;done
else echo "${0}: input type not defined corretly.";exit 1
fi

for id in `ls -p ${output_dir} | grep "/$"`
do
{
id=${id/\//}
echo samtools %{id}
samtools view -@ ${threads} -H ${output_dir}/${id}/${id}.sam > ${output_dir}/${id}/${id}_unique.sam
grep "NH:i:1" ${output_dir}/${id}/${id}.sam  >> ${output_dir}/${id}/${id}_unique.sam
samtools view -S -b ${output_dir}/${id}/${id}_unique.sam > ${output_dir}/${id}/${id}_unique.bam
samtools sort -l 4 -@ ${threads} -o ${output_dir}/${id}/${id}_unique.sort.bam ${output_dir}/${id}/${id}_unique.bam
samtools index ${output_dir}/${id}/${id}_unique.sort.bam
}
done
wait

for id in `ls -p ${output_dir} | grep "/$"`;do id=${id/\//}; echo stringtie ${id};stringtie ${output_dir}/${id}/${id}_unique.sort.bam -e -B -A ${output_dir}/${id}/${id}_gene_abundence.txt -p ${threads} -G $gtf -o ${output_dir}/${id}/${id}.gtf;done

