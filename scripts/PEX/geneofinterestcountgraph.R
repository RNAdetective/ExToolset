suppressPackageStartupMessages(library("DESeq2"))
suppressPackageStartupMessages(library("vsn"))
suppressPackageStartupMessages(library("dplyr"))
suppressPackageStartupMessages(library("ggplot2"))
suppressPackageStartupMessages(library("pheatmap"))
suppressPackageStartupMessages(library("RColorBrewer"))
suppressPackageStartupMessages(library("PoiClaClu"))
suppressPackageStartupMessages(library("ggbeeswarm"))
suppressPackageStartupMessages(library("genefilter"))
suppressPackageStartupMessages(library("sva"))
countData <- as.matrix(read.csv("/media/sf_AIDD/Results/DESeq2/gene/counts/gene_count_matrixedited.csv", row.names=1))
colData <- read.csv("/media/sf_AIDD/PHENO_DATA.csv", row.names=1)
print("do all your row names and colnames match with the PHENO_DATA file")
all(rownames(colData) %in% colnames(countData))
countData <- countData[, rownames(colData)]
print("after renaming columns with PHENO_DATA file do they still match")
all(rownames(colData) == colnames(countData))
dds <- DESeqDataSetFromMatrix(countData = countData, colData = colData, design = ~ condition)
rld <- rlog(dds, blind = FALSE)
dds <- DESeq(dds)
pcaData <- plotPCA(rld, intgroup = c("AML" "Healthy"), returnData = TRUE)
print("new pcaData matrix for creating PCAplots")
geneCounts <- plotCounts(dds, gene = "file_name", intgroup = c("AML" "Healthy"), returnData = TRUE)
tiff("/media/sf_AIDD/Results/DESeq2/gene/counts/file_namecounts.tiff")
ggplot(geneCounts, aes(x = condition, y = count, color=cell, label=rownames(pcaData))) + scale_y_log10() +  geom_beeswarm(cex = 3) +geom_text(aes(label=rownames(pcaData))) + geom_point(size = 0)
dev.off()
geneCounts <- plotCounts(dds, gene = "file_name", intgroup = c("AML" "Healthy"), returnData = TRUE)
tiff("/media/sf_AIDD/Results/DESeq2/gene/counts/file_namecounts2.tiff")
ggplot(geneCounts, aes(x = condition, y = count, color=cell, , label=rownames(pcaData))) + scale_y_log10() +  geom_beeswarm(cex = 3) + geom_line() +geom_text(aes(label=rownames(pcaData))) + geom_point(size = 0)
dev.off()
