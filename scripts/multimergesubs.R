#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)
wkd -> paste0(args[1])
level -> paste0(args[2])
file_out -> paste0(args[3])
setwd(wkd)
file_list <- list.files()
  for (file in file_list){     
    # if the merged dataset doesn't exist, create it
    if (!exists("dataset")){
      dataset <- read.csv(file)
    } 
    # if the merged dataset does exist, append to it
    if (exists("dataset")){
      temp_dataset <-read.csv(file)
      dataset<-merge(dataset, temp_dataset, by=level)
      rm(temp_dataset)
    }
   write.csv(dataset, file_out, row.names=FALSE)
  }
  datatable <- read.csv(file_out, row.names=1)
  datatranspose <- t(datatable)
  normalized <- sweep(datatable, 2, colSums(datatable), `/`)
  write.csv(datatranspose, file_out)
