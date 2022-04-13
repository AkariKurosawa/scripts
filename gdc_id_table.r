getIDtable <- function(metaFile){
  
  suppressPackageStartupMessages(library("jsonlite"))
  meta = jsonlite::fromJSON(metaFile)
  IDtable = meta[, c("associated_entities", "file_name", "file_id")]
  TCGA_barcode = sapply(IDtable$associated_entities, function(x) x[[1]][1])
  IDtable[, 1] = TCGA_barcode
  colnames(IDtable)[1] = "barcode"
  return(IDtable)
}
args=commandArgs(T)


df<-getIDtable(args[1])
write.csv(df,file=args[2],quote=F,row.names=F)	