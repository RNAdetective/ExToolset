create_pd() {
if [ ! -d "$dir_path"/Results/ ];
then
mkdir "$dir_path"/Results/ # makes directories
fi
}
define_var() {
  echo ""$phrase""
  read $variable
  if [ "$"$variable"" == 2 ];
  then
    echo ""$phrase2""
    read $variable2
  fi
}
move_PHENO() { 
cp "$home_dir"/Desktop/PHENO_DATA.csv "$dir_path"/PHENO_DATA.csv 
}
get_PHENO() { 
cd "$dir_path"
pheno_url=https://github.com/RNAdetective/AIDD/raw/master/batches/PHENO_DATAwhole.csv
wget "$pheno_url"
cd "$dir_path"/AIDD 
}
split_PHENO() {
mkdir "$dir_path"/splitfile/
PHENO="$dir_path"/PHENO_DATAwhole.csv
csvheader=`head -n 1 "$PHENO"`
split -d -l"$splitnum" "$PHENO" "$dir_path"/splitfile/PHENO_DATAbatch
for f in "$dir_path"/splitfile/* ;
do
  cat $f | sed 1i"$csvheader" >> $f.csv
  rm -f $f
done
sed -i '1d' "$dir_path"/splitfile/PHENO_DATAbatch00.csv
mv $dir_path/splitfile/PHENO_DATA"$batch".csv "$dir_path"/PHENO_DATA.csv
}
moveAIDD() { 
  cp -r "$home_dir"/AIDD/AIDD/* "$dir_path"/AIDD/
}
copy_file() {
        cp "$home_dir"/Desktop/"$j"/* "$dir_path"/indexes/"$i"_list/"$dp"/ # moves experimental gene/transcript list from the desktop to the correct index folder to be used for building own on the fly indexes for GEX and TEX tools
}
moveindexes() {
for i in gene transcript ; 
do
  for j in insert_"$i"_of_interest insert_"$i"_lists_for_pathways ;
  do
    file_dir=$(ls -A "$home_dir"/Desktop/$j/)
    if [ ! -z "$file_dir" ];
    then
      if [ "$j" == insert_"$i"_of_interest ];
      then
        dp=DESeq2
        copy_file
      else
        dp=pathway
        copy_file
      fi
    else
      echo "No indexes to move"
    fi
  done
done
}
downloadindex() {
for i in gene transcript ; 
  do
    cd "$dir_path"/indexes/"$i"_list/DESeq2/ # moves experimental gene/transcript list from the desktop to the correct index folder to be used for building own on the fly indexes for GEX and TEX tools
    wget https:/github.com/RNAdetective/AIDD/raw/master/insert_"$i"_of_interest/*
    cd "$dir_path"/indexes/"$i"_list/pathway/
    wget https:/github.com/RNAdetective/AIDD/raw/master/insert_"$i"_lists_for_pathways/*
  done
  wget https://github.com/RNAdetective/AIDDinstance/raw/master/batches/PHENO_DATA"$batch".csv
  cp "$home_dir"/PHENO_DATA"$batch".csv "$dir_path"/PHENO_DATA.csv
}
checkconfig() {
file1=config.cfg
for config in config.cfg config.cfg.defaults config.R listofconditions.csv ;
do
  path="$dir_path"/AIDD/
  if [ -f "$path"/"$config" ];
  then
    rm -f "$path"/"$config"
  fi
done 
}
config_text() {
    echo "home_dir=$home_dir
dir_path=$dir_path
ref_dir_path=$ref_dir_path
matrix_dir=$matrix_dir
pheno=$pheno
pheno_url=$pheno_url
instancebatch=$batch
batch=$batchnumber
indexes=$indexes
indexes_url=$indexes_url" >> "$dir_path"/AIDD/config.cfg
}
config_defaults() {
echo "home_dir=Default Value
dir_path=Default Value
ref_dir_path=Default Value
matrix_dir=Default Value
pheno=Default Value
instancebatch=Default Value
batch=Default Value
indexes=Default Value
indexes_url=Default Value" >> "$dir_path"/AIDD/config.cfg.defaults
}
listcon() {
cat "$dir_path"/PHENO_DATA.csv | awk 'NR==1' | sed 's/,/ /g' | sed "s/ /\n/g" | sed '1d' | sed '1d' | sed '2d' | awk '{$2=NR}1' | awk '{$3=$2+2}1' | sed 's/ /,/g' >> "$dir_path"/AIDD/listofconditions.csv # this will create
}
makeconfig() {
cd "$dir_path"/AIDD
INPUT="$dir_path"/AIDD/listofconditions.csv
OLDIFS=$IFS
{
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while IFS=, read condition number column 
do
  source config.shlib;
  home_dir=$(config_get home_dir);
  dir_path=$(config_get dir_path);
  echo "con_name$number=$condition" >> "$dir_path"/AIDD/config.cfg.defaults
  echo "con_name$number -> $condition" >> "$dir_path"/AIDD/config.R
  done
} < $INPUT
IFS=$OLDIFS #This will add directory specific information to config files 
}
con_file_create() {
cat "$dir_path"/PHENO_DATA.csv | sed -e 1d | sed -e 's/ /_/g' | cut -d',' -f$column_num | sort | uniq -ci | sed 's/ \+/,/g' | sed 's/^.//g' > $dir_to_condition
}
add_var_list() { 
echo "con_name"$con_number"="$con_name1"AND"$con_name2""  >> "$dir_path"/AIDD/config.cfg.defaults
}
add_var_list2() { 
echo "con_name"$con_number"="$con_name1"AND"$con_name3""  >> "$dir_path"/AIDD/config.cfg.defaults
}
add_var_list3() { 
echo "con_name"$con_number"="$con_name2"AND"$con_name3""  >> "$dir_path"/AIDD/config.cfg.defaults
}
add_con_list1() { 
echo "$con_name1"AND"$con_name2"",3,0"  >> "$dir_path"/listofconditions.csv
}
add_con_list2() { 
echo "$con_name1"AND"$con_name3"",4,0"  >> "$dir_path"/listofconditions.csv
}
add_con_list3() { 
echo "$con_name2"AND"$con_name3"",5,0"  >> "$dir_path"/listofconditions.csv
}
onesub_dir_create() { 
    sub_directory=$i
    mkdir "$dir_path"/$parent_directory/$sub_directory/
}
twosub_dir_create() { 
    sub_directory=$i
    mkdir "$dir_path"/$parent_directory/$sub_directory/$sub_directory2/
}
threesub_dir_create() {
  sub_directory="$i"
  sub_directory3="$j"
  mkdir ""$dir_path""/"$parent_directory"/"$sub_directory"/"$sub_directory2"/"$sub_directory3"/
}
foursub_dir_create() {
  sub_directory="$i"
  sub_directory3="$j"
  sub_directory4="$k"
  mkdir ""$dir_path""/"$parent_directory"/"$sub_directory"/"$sub_directory2"/"$sub_directory3"/"$sub_directory4"/
}
fivesub_dir_create() {
    sub_directory="$i"
    sub_directory3="$j"
    sub_directory4="$k"
    sub_directory5="$l"
  mkdir ""$dir_path""/"$parent_directory"/"$sub_directory"/"$sub_directory2"/"$sub_directory3"/"$sub_directory4"/"$sub_directory5"/
}
sixsub_dir_create() {
  sub_directory="$i"
  sub_directory3="$j"
  sub_directory4="$k"
  sub_directory5="$l"
  sub_directory6="$m"
  mkdir ""$dir_path""/"$parent_directory"/"$sub_directory"/"$sub_directory2"/"$sub_directory3"/"$sub_directory4"/"$sub_directory5"/"$sub_directory6"/
}
get_matrix() {
cp "$matrix_dir" "$dir_path"/Results
}
download_matrix() {
cd "$dir_path"/Results
wget "$matrix_url"
}
matrixeditor() {
pheno_file="$dir_path"/PHENO_DATA
Rscript "$home_dir"/ExToolset/scripts/matrix.R "$dir_path" "$file_in_dir" "$index_file" "$pheno_file" "$Rtool" # creates matrix counts with names instead of ids and checks to make sure they are there
}
####################################################################################################################
# SET UP PARENT DIRECTORIES, PHENO_DATA, AND SET-UP CONFIG FILES AND LIST OF CONDITIONS
####################################################################################################################
AIDD="$1" # 1=if you already ran AIDD 2=need to get matrix files and move to new created results
default="$2" # default 1=have pheno data file on desktop, not running a batch, have indexes on desktop, and matrix files in folder on desktop
home_dir="$3" # home directory is second space
dir_path="$4" # working directory is third space
if [ ! -d "$dir_path" ];
then
  mkdir "$dir_path"
fi
ref_dir_path="$home_dir"/AIDD/references # this is where references are stored
if [ "$AIDD" == "2" ];
then
  create_pd
  if [ "$default" == 1 ];
  then
    matrix=1
    matrix_dir="$home_dir"/Desktop/put_counts_here
    pheno=1
    instancebatch=1
    indexes=1
  fi
  if [ "$default" == 2 ];
  then
    phrase=$(echo "Do you have your matrix files in the desktop folder? 1=yes(default) 2=no(please download it)")
    variable=matrix
    phrase2=$(echo "What is the directory where your matrix files are located?")
    variable2=matrix_url
    define_var
    phrase=$(echo "Do you have you pheno_data file ready to go? 1=yes(default) 2=no(please download it)")
    variable=pheno
    phrase2=$(echo "What is the url for your pheno_data file?")
    variable2=pheno_dir
    define_var
    phrase=$(echo "Do you want to run ExToolset just once? 1=yes(default) 2=no(batch set)")
    variable=instancebatch
    phrase2=$(echo "What is your batch number?")
    variable2=batch
    define_var
    phrase=$(echo "Do you have your indexes in the folders on the desktop? 1=yes(default) 2=no(please down them)")
    variable=indexes
    phrase2=$(echo "What is the url for your indexes?")
    variable2=indexes_dir
    define_var
  fi
  if [ "$pheno" == "1" ];
  then
    move_PHENO
  fi
  if [[ "$pheno" == "2" && "$batchinstance" == "1" ]];
  then
    get_PHENO
  fi
  if [[ "$pheno" == "2" && "$batchinstance" == "2" ]];
  then
    get_PHENO
    split_PHENO
  fi
  moveAIDD
  checkconfig
  if [ ! "$(ls -A )" ];
  then
    moveindexes  # MOVE AIDD INDEXES TO EXPERIMENT DIRECTORY
  else
    echo "NO INDEX FILES TO MOVE"
  fi
  if [ "$indexes" == 2 ]; # HOME DIRECTORY FOLDER ADD IN OPTION IN BEG #######indexes 1=yes 2=no (means download them) FOR DOWNLOAD INDEXES
  then
    downloadindex
  fi 
  config_text # MAKES CONFIG TEXT
  config_defaults # MAKE CONFIG DEFAULTS TEXT
  listcon # MAKES LISTS OF CONDITIONS FILE
  cd "$dir_path"/AIDD
  makeconfig # MAKES CONFIG FILES
####################################################################################################################
# FINISHES ADDING CONDITION NAMES TO CONFIG FILES
####################################################################################################################
  cd "$dir_path"/AIDD
  source config.shlib; # load the config library functions
  INPUT="$dir_path"/AIDD/listofconditions.csv
  OLDIFS=$IFS  
  {
  [ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
  while IFS=, read condition number column
  do
    con_name1=$(awk -F, 'NR==1{print $3}' "$dir_path"/PHENO_DATA.csv)
    con_name2=$(awk -F, 'NR==1{print $5}' "$dir_path"/PHENO_DATA.csv)
    con_name3=$(awk -F, 'NR==1{print $6}' "$dir_path"/PHENO_DATA.csv)
    con_name4=$(awk -F, 'NR==1{print $7}' "$dir_path"/PHENO_DATA.csv)
    column_num="$column"
    if [ "$column" == 3 ];
    then
      dir_to_condition="$dir_path"/$condition.csv
      column_num="$column"
      con_file_create
    fi
    if [ "$column" == 4 ];
    then
      dir_to_condition="$dir_path"/$condition.csv
      con_file_create
      dir_to_condition="$dir_path"/"$con_name1"AND"$con_name2"
      column_num=3,4
      con_number="$column"
      con_file_create
      add_var_list
      add_con_list1
    fi
    if [ "$column" == 5 ];
    then
      dir_to_condition="$dir_path"/$condition.csv
      con_file_create
      dir_to_condition="$dir_path"/"$con_name1"AND"$con_name3"
      column_num=3,5
      con_number="$column"
      con_file_create
      add_var_list2
      add_var_list3
      add_con_list2
      add_con_list3
    fi
  done
  } < $INPUT
  IFS=$OLDIFS
####################################################################################################################
# CREATES SUB DIRECTORIES TO AIDD PARENT DIRECTORIES ALREADY CREATED FOR RAW_DATA AND EXTOOLSET
####################################################################################################################
  dir_path="$1" # first option is where the Results folder should be created
  parent_directory=Results
  for i in DESeq2 topGO pathway variant_calling ; 
  do
    onesub_dir_create
    INPUT="$dir_path"/listofconditions.csv
    IFS=$OLDIFS
    {
    [ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
    while IFS=, read condition number column
    do
      sub_directory2="$condition"
      twosub_dir_create
      for j in gene transcript ;
      do
        threesub_dir_create
        if [ "$i" = DESeq2 ]; 
        then
          for k in calibration counts differential_expression PCA ;
          do
            foursub_dir_create
            if [ "$k" == differential_expression ];
            then
              for l in excitome geneofinterest venndiagram ;
              do
                fivesub_dir_create
              done
            fi
          done
        fi
        if [ "$i" = pathway ]; 
        then
          for k in heatmaps tables volcano ;
          do
            foursub_dir_create
          done
        fi
        if [ "$i" = variant_calling ]; 
        then
          for k in amino_acid impact nucleotide substitutions ;
          do
            foursub_dir_create
            if [ "$k" == impact ];
            then
              for l in high_impact moderate_impact ;
              do 
                fivesub_dir_create
                for m in con_var1 con_var2  ;
                do
                  sixsub_dir_create
                done
              done
            fi
          done
        fi
      done
    done
    } < $INPUT
    IFS=$OLDIFS
  done
  if [ "$matrix" == "1" ];
  then
    get_matrix
  fi
  if [ "$matrix" == "2" ];
  then
    download_matrix
  fi
fi
####################################################################################################################
# RUNS EXTOOLSET FOR GENE AND TRANSCRIPT EXPRESSION ANALYSIS
####################################################################################################################
file_in_dir="$dir_path"/Results/
Rtool=GTEX
index_file="$home_dir"/ExToolset/indexes/index/"$level"_names.csv
matrixeditor
#bash "$home_dir"/AIDD/AIDD/scripts/GEX_TEX.sh
#bash "$home_dir"/AIDD/AIDD/scripts/PEX.sh
####################################################################################################################
# RUNS EXTOOLSET FOR RAW GLOBAL VEX
####################################################################################################################
conditionname1=$(awk -F, 'NR==2{print $2}' "$dir_path"/condition.csv)
conditionname2=$(awk -F, 'NR==3{print $2}' "$dir_path"/condition.csv)
##takes raw global variant calling results and makes count_matrix files 
INPUT="$dir_path"/PHENO_DATA.csv
OLDIFS=$IFS
{
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
read
while IFS=, read -r samp_name run condition sample condition2 condition3
do
  cat "$dir_path"/Results/snpEff"$run".csv | sed '1d' | sed 's/# />/g' | sed 's/\//_/g' | sed  '/^\s*$/d' | sed 's/Base/'$samp_name'nucleotide_count_matrixprep/g' | sed 's/Amino/'$sample_name'amino_acid_count_matrixprep/g' >> /media/sf_AIDD/Results/variant_calling/substitutions/"$run".csv
  wkd="$dir_path"/Results/variant_calling/substitutions
  if [ ! -d "$wkd"/raw/ ];
  then
    mkdir "$wkd"/raw/
    mkdir "$wkd"/raw/"$samp_name"/
  fi
  cd "$wkd"/raw/"$samp_name"/
csplit -s -z "$wkd"/"$samp_name".csv '/>/' '{*}'
  for i in xx* ; do \
    n=$(sed 's/>// ; s/ .*// ; 1q' "$i") ; \
    mv "$i" "$n.csv" ; \
    sed -i '1d' "$n.csv"
 done
  for level in nucleotide amino_acid ;
  do
    file_in="$wkd"/raw/"$samp_name"/"$samp_name""$level"_count_matrixprep.csv
    if [ "$level" == "nucleotide" ] ; then
      sed -i '1,5d' "$file_in"
    fi
    if [ "$level" == "amino_acid" ] ; then
      sed -i '1,23d' "$file_in"
    fi
    sed -i "1i x,"$samp_name"" "$file_in"
    index_file="$home_dir"/ExToolset/indexes/index/"$level"_names.csv
    wkd="$dir_path"/Results/variant_calling/"$level"/merge
    if [ ! -d "$wkd" ];
    then
      mkdir "$wkd"
    fi
    dir_path="$file_in"
    file_in_dir="$wkd"/"$samp_name""$level"_count_matrixprep.csv
    Rtool=G_VEX
    matrixeditor 
  done
done 
} < $INPUT
IFS=$OLDIFS
for level in nucleotide amino_acid ;
do
  dir_path="$dir_path"
  wkd="$dir_path"/Results/variant_calling/"$level"/merge
  file_out="$dir_path"/Results/variant_calling/"$level"/"$level"_count_matrix.csv
  Rscript /media/sf_AIDD/ExToolset/G_VEX/multimergesubs.R "$wkd" "$level" "$file_out"
  index_file="$home_dir"/Desktop/put_counts_here/all_summarynorm.csv
  if [ -s "$index_file" ];
    cp "$index_file" "$dir_path"/Results/
  else
    echo "Can't find alignment summary file to normalizes variants"
  fi
  file_in_dir="$wkd"
  Rtool=G_VEX2
  matrixeditor
# now make my tables bargraphsubs.R
done
fi
####################################################################################################################
# RUNS EXTOOLSET FOR IMPACT PREDICTION VEF
####################################################################################################################
level1=high_impact
level2=moderate_impact
pickRtool=I_VEX
var1=$(awk -F, 'NR==1{print $1}' "$matrix_file")
variable1=$(echo ""$level"id")
      file_in="$dir_path"/Results/"$level"_count_matrix.csv
      file_out="$dir_path"/Results/"$level"_count_matrixedited.csv
matrixeditor

bash "$home_dir"/AIDD/AIDD/scripts/I_VEX.sh
####################################################################################################################
# RUNS EXTOOLSET FOR ANOVA AND CORRELATION BETWEEN GTEX AND VEX
####################################################################################################################







