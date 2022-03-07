library("clusterProfiler")

###edit area start###
colData<-""     #edit DESeq2 colData here(remember to relevel!)
countData<-""    #edit DESeq2 countData here(leave it blank if use tximport)
#rownames(countData)<-countData[,1]
#countData<-countData[,-1]
txi<-""    #load tximport object here(leave it blank if import use count table directly)
design<-""  #edit DESeq2 design formula here(string)
contrasts<-list(c("","",""))    #set results to extract(in contrast form), add multiple contasts to extract multiple results and leave it blank if default result is needed
FC_threshold <- 1 # threshold of abs(log2FC)
pvalue_adjust <- F
pvalue_threshold <- 0.01
PCA<-T   #output PCA plot or not (bool)
heatmap<-T   #output heatmap or not (bool)
volcano<-T   #output volcano plot or not (bool)
output_path<-"./"    #path to export results
output_prefix<-""

###edit area end###