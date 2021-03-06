#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)
suppressPackageStartupMessages(library("gdata"))
suppressPackageStartupMessages(library("VennDiagram"))
suppressPackageStartupMessages(library("gplots"))
file_in <- paste0(args[1])
image_out <- paste0(args[2])
file_out <- paste0(args[3])
gLists <- read.csv(file_in)
gLists$X <- NULL
head(gLists)
tail(gLists)
gLS <- lapply(as.list(gLists), function(x) x[x != ""])
lapply(gLS, tail)
names(gLS) <- c(set_column_name)
VENN.LIST <- gLS
tiff(image_out, units="in", width=10, height=10, res=600)
venn.plot <- venn.diagram(VENN.LIST, NULL, category.names=c(set_column_name), fill=c(set_colors), alpha=c(set_alpha), cex = 2, cat.fontface=4)
grid.draw(venn.plot)
dev.off()
a <- venn(VENN.LIST, show.plot=TRUE)
str(a)
inters <- attr(a,"intersections")
lapply(inters, head)
sink(file_out)
inters
sink()
