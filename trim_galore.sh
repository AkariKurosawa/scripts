#!/bin/bash

usage() {
  echo "Usage: ${0} [-h|--help] [-j|--cores] <INT> [-q|--quality] <INT> [--phred33] [--phred64] [-s|--stringency] <INT> [-l|--length] <INT> [-g|--gzip] [-p|--paired] [-o|output_dir] <string> [-i|--input_dir] <string>" 1>&2
  exit 1 
}

ARGS=`getopt -o "hj:q:cds:l:gpo:i:" --long "help,cores:,quality:,phred33,phred64,stingency:,length:,gzip,paired,output_dir,input_dir" -n "getopt.sh"  -- "$@"`

if [ $? != 0 ] ; then usage; exit 1 ; fi
eval set -- "$ARGS"

cores=8
quality=20
phred33=0
phred64=0
stringency=3
length=20
gzip=0
paired=0

while true ; do
        case "$1" in
                -h|--help) usage; exit 1 ; shift ;;
                -j|--cores) cores=$2 ; shift 2 ;;
                -q|--quality) quality=$2;shift 2;;
	-c|--phred33) phred33=1;shift;;
	-d|--phred64) phred64=1;shift;;
	-s|--stringency) stringency=$2;shift 2;;
	-l|--length) length=$2;shift 2;;
	-g|--gzip) gzip=1;shift;;
	-p|--paired) paired=1;shift;;
	-o|--output_dir) out=$2;shift 2;;
	-i|--input_dir) dir=$2;shift 2;;
                --) shift ; break ;;
                *) echo "Internal error!" ; exit 1 ;;
        esac
done

string1="trim_galore -j ${cores} -q ${quality} --stringency ${stringency} -o ${out}"
if [ $gzip -eq 1 ];then string1=${string1}" --gzip";fi
if [ $phred33 -eq 1 ];then string1=${string1}" --phred33";fi
if [ $phred64 -eq 1 ];then string1=${string1}" --phred64";fi

if [ ! -d ${out} ];then mkdir -p ${out};fi

if [ ${paired} -eq 1 ];then
for file in `ls ${dir}/*_1.fastq*` ;do ${string1} --paired ${file} ${file//_1.fastq/_2.fastq};done
else
for file in `ls ${dir}/*.fastq*` ;do ${string1} "${file}";done
fi


if [ ! -d ${out}/report ];then mkdir ${out}/report;fi
for file in `ls -p -d ${out}/*report* | grep -v "/$"`;do mv ${file} ${out}/report;done
for file in `ls ${out}/*fq*`;do mv ${file} ${file/fq/fastq};done
for file in `ls ${out}/*_1_val_1*`;do mv ${file} ${file/_1_val_1/_val_1};done
for file in `ls ${out}/*_2_val_2*`;do mv ${file} ${file/_2_val_2/_val_2};done

