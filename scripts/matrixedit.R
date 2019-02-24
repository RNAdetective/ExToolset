#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)
dir_path <- paste0(args[1])
input_dir <- paste0(args[2])
input_file <- paste0(input_dir,level,"_count_matrix.csv")
output_file <- paste0(input_dir,level,"_count_matrixedited.csv")
index_file <- paste0(args[3])
pheno_file <- paste0(args[4])
Rtool <- paste0(args[5])
if ( Rtool == "GTEX" ) {
  for ( level in "gene" "transcript" ) {
    matrix <- read.csv(input_file) # LOAD MARTRIX
    colnames(matrix)[1] <- paste0(level,"_id") # ADD COLUMN NAME
    index <- read.csv(index_file) # LOAD INDEX WITH GENE NAMES
    if ( level == "transcript" ) {
      # filter by column 4 protein_coding
      index2 <- index[c(2,3,1,4)] # SET COLUMN ORDER
      index2[3] <- NULL # REMOVES EXTRA COLUMN IN TRANSCRIPT 
      index2[3] <- NULL # REMOVES EXTRA COLUMN IN TRANSCRIPT
     }
  rename <- merge(index2, matrix, by="level_id") # COMBINES INDEX WITH MARTIX
  rename[1] <- NULL # GETS RID OF OLD ID NUMBER
  row.names(final) <- final$level_name # RENAMES INDEX COLUMN
  final[1] <- NULL 
  Data <- read.csv(pheno_file, row.names=1) # READS PHENO_DATA
  colnames(final) <- rownames(Data) # ADDS SAMPLE NAMES DEFINED BY USER TO MATRIX
  write.csv(final, output_file) # WRITES THE NEWLY NAMED MATRIX FILE
  }
} else if ( Rtool == "G_VEX" ) {
library("data.table")
input_file=paste0(args[1])
output_file=paste0(args[2])
data <- read.csv(input_file)
data2 <- as.matrix(data)
data3 <- as.vector(data2)
index <- read.csv(index_file)
final <- merge(index, data3, by="x")
final$x <- NULL
write.csv(final, file_out, row.names=FALSE)
}
} else if ( Rtool == "G_VEX2" ) { 
data <- read.csv(input_file)
colnames(data)[1] <- "name"
data_summary <- read.csv(index_file) ## want to divid by read depth not by colSums
colnames(data_summary)[1] <- "name"
colnames(data_summary)[2] <- "totalcounts"
final <- merge(data, data_summary, by="name") # add column at the end
normalized <- sweep(final, 2, final$totalcounts, `/`)
write.csv(normalized, output_file)
}

