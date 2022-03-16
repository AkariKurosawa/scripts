#220216
##1.create DESeq2_heatmap_volcano.r

#220217
##1.complete DESeq2_heatmap_volcano.r
complate test and rename as.template, upload to github

#220222
##1.edit module sh files
fastqc.sh, fq_dump.sh, hisat2_stringtie.sh, kallisto_quant.sh, kallisto_quant.sh

##2.create pipeline folder
add fq_dump_trim-galore_fastqc_hisat2_stringtie_single.sh and fq_dump_trim-galore_fastqc_hisat2_stringtie_single.sh, for template of single/paired srr respectively.

#220223
##1.create runinfo_runids.sh
usage: bash runinfo_runids.sh <PRJNA number>

##2.create pipline fq-dump_trim-galore_fastqc_kallisto

#220307
##1.create clusterProfiler.r
finish test, upload to github

#220316
##1.fix bug in pipelines
- add -g in trim-galore command in all paired and single pipelines
- add -p in trim-galore command in paired pipelines
- fix kallisto command(no -l and -s in paired mode) 