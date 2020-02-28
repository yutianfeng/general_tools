#assumes blast+ and iqtree, and muscle. also requires supermatrix.py and wrapper_supermatrix.py in the a usable path or PATH

for f in * (names of genomes in fasta).fasta; do makeblastdb -i $f -dbtype nucl; done
#need names of genomes in nucleotide fasta format

for x in *.blast; do while IFS=$'\t' read -r -a myArray; do NAME="${myArray[1]}"; START="${myArray[8]}"; STOP="${myArray[9]}"; done < "$x" ; if [ "$START" -gt "$STOP" ]; then STRAND=2;  RANGE="$STOP"-"$START"; else STRAND=1; RANGE="$START"-"$STOP"; fi;
 g=${x%.blast}; fastacmd -d /home/yuf17006/Frankia_project/Small_Data_tests/Genomes/"$g" -p F -s "$NAME"  -L "$RANGE" -S "$STRAND" -o "$x".grab; done;
#grabs top scoring hit for each gene outputs them to the same gene file

#align them all with muscle
for g in *.grab; do muscle -in $g -out $g.align -maxiters 4; done

#all taxa must have the same names in every gene file



#instructions for using supermatrix concatenater
#Attached are two py scripts.  On the cluster, create a directory in your home folder called scripts.  copy the two files there.  
#In the texteditor of your choice, edit the file .bash_profile (dot files are usually not listed ...)
#In that file should be a description of your PATH.  Something like 
#PATH=$PATH:$HOME/bin:/opt/454/bin
#You need to add the script folder to the path.  in the example above, after editing the line would read 
#​P​ATH=$PATH:$HOME/bin:/opt/454/bin:$HOME/scripts 
​#Then, 
#create a folder that contains the alignments you want to concatenate
#Create a text file that lists all the names of the individual alignments.
#save that file (possible Alist.txt) 
#Invoke the wrapper by typing 
#wrapper_supermatrix.py Alist.txt
#​The contents of alist would look something like this: 
#list1_aligned.fst
#list2_aligned.fst
#list3_aligned.fst
#list4_aligned.fst
#list5_aligned.fst
#list7_aligned.fst
#​The program creates a lot of output on the screen and in the directory where your alignments were. 
#Essentially if you ave 31 files, the program runs 30 time, creating a concatenated alignment every time.  Outfile30 would be the concatenation you want to work with.  But check the logs, the missingseqs and partition lists files, in case something went wrong ...   And, obviously, look at the final alignment in seaview or similar.
​

wrapper_supermatrix.py Alist.txt 

#take the final concatenated alignments and turn them into codons, proteins or leave them 
#can use as input into iqtree
iqtree -st (codon, AA, or NT) -bb 1000+ -nt AUTO 

#view tree