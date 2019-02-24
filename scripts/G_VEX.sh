#!/usr/bin/env bash
conditionname1=$(awk -F, 'NR==2{print $2}' /media/sf_AIDD/condition.csv)
conditionname2=$(awk -F, 'NR==3{print $2}' /media/sf_AIDD/condition.csv)
##this will create individual averages and bargraphs for each individual substitution
for i in nucleotide amino_acid ; do
IFS=$OLDIFS
INPUT=/media/sf_AIDD/indexes/index/"$i"imp.csv
OLDIFS=$IFS
IFS=,
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read  sub_names
do
    sed -i 's/file_name/'$sub_names'/g' /media/sf_AIDD/ExToolset/G_VEX/bargraphssubs.R
    sed -i 's/sub_level/'$i'/g' /media/sf_AIDD/ExToolset/G_VEX/bargraphssubs.R
    sed -i 's/set_x/x='$sub_names'avg/g' /media/sf_AIDD/ExToolset/G_VEX/bargraphssubs.R
    sed -i 's/set_fill/fill=condition/g' /media/sf_AIDD/ExToolset/G_VEX/bargraphssubs.R
    sed -i 's/set_barcolors/"red", "blue"/g' /media/sf_AIDD/ExToolset/G_VEX/bargraphssubs.R
    sed -i 's/set_group/condition/g' /media/sf_AIDD/ExToolset/G_VEX/bargraphssubs.R
Rscript  /media/sf_AIDD/ExToolset/G_VEX/bargraphssubs.R
    sed -i 's/'$sub_names'/file_name/g' /media/sf_AIDD/ExToolset/G_VEX/bargraphssubs.R
    sed -i 's/'$i'/sub_level/g' /media/sf_AIDD/ExToolset/G_VEX/bargraphssubs.R
    sed -i 's/x=file_nameavg/set_x/g' /media/sf_AIDD/ExToolset/G_VEX/bargraphssubs.R
    sed -i 's/fill=condition/set_fill/g' /media/sf_AIDD/ExToolset/G_VEX/bargraphssubs.R
    sed -i 's/"red", "blue"/set_barcolors/g' /media/sf_AIDD/ExToolset/G_VEX/bargraphssubs.R
    sed -i 's/condition/set_group/g' /media/sf_AIDD/ExToolset/G_VEX/bargraphssubs.R
done < $INPUT
IFS=$OLDIFS
done
##adds names to averages tables for merging into one big figure
for i in nucleotide amino_acid ; do
INPUT=/media/sf_AIDD/indexes/index/"$i"imp.csv
OLDIFS=$IFS
IFS=,
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read  sub_names
do
  sed -i 's/file_name/'$sub_names'/g' /media/sf_AIDD/ExToolset/G_VEX/relabelsubs.R
  sed -i 's/sub_level/'$i'/g' /media/sf_AIDD/ExToolset/G_VEX/relabelsubs.R
  Rscript /media/sf_AIDD/ExToolset/G_VEX/relabelsubs.R
  sed -i 's/'$sub_names'/file_name/g' /media/sf_AIDD/ExToolset/G_VEX/relabelsubs.R
  sed -i 's/'$i'/sub_level/g' /media/sf_AIDD/ExToolset/G_VEX/relabelsubs.R
done < $INPUT
IFS=$OLDIFS
done
##combines averages and SD for all substitutions in one figure
for i in nucleotide amino_acid ; do
  sed -i 's/sub_level/'$i'/g' /media/sf_AIDD/ExToolset/G_VEX/rbindsubs.R
  Rscript /media/sf_AIDD/ExToolset/G_VEX/rbindsubs.R
  sed -i 's/'$i'/sub_level/g' /media/sf_AIDD/ExToolset/G_VEX/rbindsubs.R
done
##makes all in one figure
Rscript /media/sf_AIDD/ExToolset/G_VEX/subsbargraphs.R
