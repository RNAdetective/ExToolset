# ExToolset

## Running ExToolset

Step 1: Make sure AIDD virutalbox is up an running following the steps outlined in AIDD.

Step 2: Follow the instructions on the desktop.
* 1.) Open PHENO_DATA.csv on the desktop and fill out for your experiment.

        * a.) On the desktop you will find a file PHENO_DATA.csv add your experimental information into this file
        
        * b.) column 1: the sample names for each sample you wish to use to label graphs and tables for the results.
        
        * c.) column 2: the SRA run identification number or the name of the .fastq file you are using from non-public data.
        
        * d.) column 3: this is the main condition for the experiment for example AML or healthy (make sure to use this term instead of control). DO NOT use the word control because DESeq2 will not accept this as a condition.
        
        * e.) column 4: this is the sample number used to create matrix it is just sample01-sample what ever your last sample number is. Make sure if you have over a hundred samples that you use sample001. 
        
        * f.) column 5-6: these are addition conditions to be with multivariate analysis if you do not have any additional conditions leave them empty.
        
        * g.) Now save the new data with the same name on the desktop.

* 2.) Insert any gene lists of interest into the insert_gene_of_interest folder on the desk top.  Make .csv files with the first column numbered 1-X.  Then in the second column list your genes you want on one bar graph.  Also open GOI.csv and add to the list of genes any you want line graph count graphs for as well as a included in the table of gene of interest results.

* 3.) Do the same for transcript lists of interest into the insert_transcript_of_interest fold making sure you add your transcript of interest to the TOI.csv file.

* 4.) Add any pathway lists to the insert_gene_lists_for_pathways folder on the desktop.  Make a csv file that contains the first column labeled gene numbered 1-X.  Then in the second column labeled gene_name enter as many genes you want to include in that pathway.  Then name the file XXXXXXXX.csv (the name of your pathway) then add this name to the csv file pathway_list in the same format as the others on the list.

* 5.) repeat this same procedure but for the insert_transcript_lists_for_pathways folder on the desktop.  Making sure to add you pathway names to the csv file names pathwayT_list.

Step 3: copy and paste the following command into the command prompt

```
bash /home/user/AIDD/ExToolset.sh 1 /home/user /media/AIDD
```
ExToolset is designed to run after AIDD pipeline is complete it depends on directories created during the pipeline and need the files in the right locations if you would like to run ExToolset without running AIDD first simply change the argument 1 in the command prompt to 2 and follow the instructions below on where to put your data.

### If you did not run AIDD pipeline then follow these directions on where to place your files to run ExToolset.

Step 1: Place all folders and files into the folder on the desktop called put_counts_here

  * You need to have the alignment_metrics summary folder with all samples listed in PHENO_DATA file having a csv derived from variant calling part of AIDD or instead you can put the all read depth summary matrix file
  
  * You need to have the ballgown folder from raw_data from AIDD results or alternatively both gene_count_matrix.csv and transcript_matrix.csv if those were created already
  
  * You need to have the snpEff folder from raw_data from AIDD results including all output for all samples in PHENO_DATA file

Step 2: copy and paste the following command into the command prompt

```
bash /home/user/AIDD/ExToolset.sh 2 /home/user /media/sf_AIDD
```
/media/sf_AIDD can be changed to whatever directory you would like to save the results too 
___
## Pipeline Flow Chart
![Screenshot](flow_chart.png)
## Built With
Ubuntu 18.04 VirtualImage

R packages
* [Bioconductor packages] (https://www.bioconductor.org/)
* [DESeq2] (https://bioconductor.org/packages/release/bioc/html/DESeq2.html)
* [DEXseq] (http://bioconductor.org/packages/release/bioc/html/DEXSeq.html)
* [Ballgown] (http://bioconductor.org/packages/release/bioc/html/ballgown.html)
* [Ggplot2] (https://cran.r-project.org/web/packages/ggplot2/index.html)
* [topGO] (http://bioconductor.org/packages/release/bioc/html/topGO.html)

___

## References for tools.

Love, M. I., Huber, W., & Anders, S. (2014). Moderated estimation of fold change and dispersion for RNA-seq data with DESeq2. Genome Biology, 15(12). http://doi.org/10.1186/s13059-014-0550-8

___
