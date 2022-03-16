#!/bin/bash

usage() {
  echo "Usage: ${0} [-h|--help] [-t|--threads] <INT> [-l|--length] <INT> [-s|--sd] <INT> [-b|--bootstrap-samples] <INT>  [--single] [-o|--output_dir] <string> [-i|--index] <string> [-f|--fastq_dir]<string>" 1>&2
  exit 1 
}

ARGS=`getopt -o "ht:l:s:b:o:i:f:" --long "help,threads:,length:,sd:,bootstrap-samples:,single,output_dir:,index:,fastq_dir:" -n "getopt.sh"  -- "$@"`

if [ $? != 0 ] ; then usage; exit 1 ; fi
eval set -- "$ARGS"

threads=8
length=180
sd=20
bootstrap=0
single=0


while true ; do
        case "$1" in
                -h|--help) usage; exit 1 ; shift ;;
                -t|--threads) threads=$2 ; shift 2 ;;
                -l|--length) length=$2;shift 2;;
	-s|--sd) sd=$2;shift 2;;
	-b|--bootstrap-samples) bootstrap=$2;shift 2;;
	--single) single=1;shift;;
	-o|--output_dir) output_dir=$2;shift 2;;
	-i|--index) index=$2;shift 2;;
	-f|--fastq_dir) fastq_dir=$2; shift 2;; 
                --) shift ; break ;;
                *) echo "Internal error!" ; exit 1 ;;
        esac
done


string1="kallisto quant -i ${index}"
if [ ${single} -eq 1 ];then string1=${string1}" --single -l "${length}" -s "${sd};fi
if [ ${bootstrap} -gt 0 ];then string1=${string1}" -b "${bootstrap};fi


if [ ! -d ${output_dir} ];then mkdir -p ${output_dir};fi

if [ ${single} -eq 1 ];then
for path in `ls ${fastq_dir}/*.fastq*` ;do file=${path##*/};${string1} -o ./${output_dir}/${file%.fastq*}/ -t ${threads} ./${path} ;done
else
for path in `ls ${fastq_dir}/*_1.fastq*` ;do file=${path##*/};${string1} -o ./${output_dir}/${file%.fastq*}/ -t ${threads} ./${path} ${path/_1.fastq/_2.fastq};done
fi
 
