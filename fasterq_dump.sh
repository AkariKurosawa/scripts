#!/bin/bash 

usage() {
  echo "Usage: ${0} [-h|--help] [-e|--threads] [int] [-i|--input_ids] <STRING> [-o|--output_dir] <STRING> [-n|--reads_number] [INT]"  1>&2
  exit 1 
}

ARGS=`getopt -o "hei:o:n:" --long "help,threads,input_ids:,output_dir:,reads_number:" -n "getopt.sh"  -- "$@"`

if [ $? != 0 ] ; then usage; exit 1 ; fi
eval set -- "$ARGS"

threads=8
reads_number=0

while true ; do
        case "$1" in
	-h|--help) usage;exit 1;shift;;
	-e|--threads) threads=$2;shift 2;;  
	-i|--input_ids) input_ids=$2;shift 2;;
	-o|--output_dir) output_dir=$2;shift 2;;
	-n|--reads_number) reads_number=$2;shift 2;;
	--) shift ; break ;;
                *) echo "Internal error!" ; exit 1 ;;
        esac
done

if [ ! -d ${output_dir} ];then mkdir -p ${output_dir};fi

string1="fasterq-dump -e ${threads} -O ${output_dir}"
if [ ${reads_number} -gt 0 ];then string1="${string1} -X ${reads_number}";fi 
string1="${string1}  --split-files"

for id in `cat ${input_ids}`;do 
{
${string1} ${id}
#rm ~/SRR/sra/${id}.sra.cache 
}
done

