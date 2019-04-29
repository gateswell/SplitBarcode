# SplitBarcode
The repository provides scripts for spliting PE fastq from MGI sequencer platform by barcodes sequence. 
## Author
The current implementation was written by caoshuhuan (caoshuhuan@yeah.net). 
I would appeciate if you send email to me when you have any question about this script or report bug ! 
## Version history
The current code version is v1.0.1  

v1.0  
 - split PE fastq with single barcode 
 - outputs are compressed 
 - some statistical results provided  
v1.0.1 
 - delete parameter `-l`
 - modified compress method to reduce process time  
 - submit `SplitDualBarcodes.pl` for MGI dual barcodes multiplexing, type in `perl SplitDualBarcodes.pl -h` to get the tutorial of this script  
v1.1 *(under deverlopment)* :
 - intergrate single and dual barcodes multiplexing module 
 - support windows system 
## Prerequisites, Tutorial and Results
System: `Linux`  
Memmory: **1 Gb** or above  
Storage: **1 Tb** or above  
Perl version: `5.16` or above  

The script runs on `CentOS 7` or other linux systems on a **64Bit** machine with `Perl 5.26`, for **100Gb** data, It will take about **2 hours** with **1 Gb** memory if final fastqs uncompress.
 
###  Tutorial
```
Usage:
	perl splitBarcode_PE.pl [options]
		*-r1 --read1 <string>		read1.fq.gz
		*-r2 --read2 <string>		read2.fq.gz
		 -e  --errNum <int>		mismatch number [default: 2]
		*-f  --firstCycle <int>		First cylce of barcode
		*-l  --lastCycle <int>		Last cycle of barcode
		*-b  --barcodeList <string>	barcodes list
		 -rc --revcom	<Y|N>		generate reverse complement of barcode.list or not
		 -c  --compress <Y|N>		compress(.gz) output or not [default: Y]
		 -o  --outdir <string>		output directory [default: ./]
		 -h  --help			print help information and exit
```
- `*` means parameter must be provided.
- the default mismatch value is **2**.
- the default output directory is `./`.
- the fastq will be compressed in **.gz** format when `-c Y` has been set and run `gzip.main.sh` after split process finished. 
#### Command line example 
```
perl SplitBarcode.pl -r1 read1.fq.gz -r2 read2.fq.gz -e 1 -f 101 -l 110 -b barcode.list -r N -o /path/outdir -c Y
```
Please make sure the **first cycle number** of barcode correctly. 
#### barcode list example
Only barcode name and  barcode sequence need, seperated by `tab` or `space`.  
barcode will miss if lane starts with `#`, for example: `#96	ATGATCTAGC`.
```
1	ATGCATCTAA
2	AGCTCTGGAC
```
The default barcode sequence is a reverse complement of sequence between first cycle and last cycle in Read_2 fastq file. If not, set parameter `-rc N`.  
for example:  
if one read from read2 fastq is:

```
@V300000000L1C001R001000000/2
TGACTCAATCATACGTTTATACCTCCTATAGTAAAAAGTTTTGTCTTCTTTCAGATATAAGTGTCTCTGTGATGCAGGCTGGGTTGGCATCAACTGTGAATCATTCCAAC
+
FEFGEGGGFGGEEGEFGEEEEBGEFDEEGDBGEGEEAFFGGGDGFEEEEFEFFGFGEFCGDEEFGGEFEEECGBEDEGFFDFFEFEGDGGFFE?EEDCFF71,'962'&)
``` 
the barcode sequence in read 2 is **TCATTCCAAC**,  
the read can be splited perfectly when the barcode provided is **GTTGGAATGA** or **TCATTCCAAC**  

### Output 
There are several types of file generated after script finished：
- barcode_1.fq(.gz), barcode_2.fq(.gz)
- BarcodeStat.txt
- TagStat.txt

#### - barcode fastq
The format of fastq name is:

> Chipname_lane_barcode_1.fq.gz : ` V300000000_L01_1.fq.gz`  
> Chipname_lane_barcode_2.fq.gz : ` V300000000_L01_2.fq.gz`  

Chip name and lane name are captured from the read1.fq.gz. 
Also there is a couple of fastq named `undecoded_1.fq.gz` and `undecoded_2.fq.gz`, to keep reads which don't contain any barcode sequence. 
#### - BarcodeStat.txt
BarcodeStat.txt counts the reads number and barcode split ratio of different barcode separately. In finally, the *Total* lane calculate the total reads number and ratio.  
The format of BarcodeStat.txt
``` 
#SpeciesNO	Correct	Corrected	Total	Pct
1	95327109	4112238	99439347	19.2152%
2	93797238	6267736	100064974	19.3361%
...
Total	468560368	27305422	495865790	95.8187%
```
|column|name|description|
|--| -------- | --------|
|1|SpeciesNO |barcode name |
|2|Correct       |the number of reads without mismatch | 
|3|Corrected |the number of reads within mismatch value|
|4|Total |Correct and Corrected reads number |
|5|Pct|percentage|
#### - TagStat.txt
Tag means a short sequence locate between the first cylce and last cycle on Read 2 fastq. TagStat.txt exhibit all tag number and percentage.  
The format of TagStat.txt is: 
```
#Tag	SpeciesNO	readCount	Pct
ATGCATCTAA	1	99439347	19.2152%
...
ATGATCTAGC	unknow	200	0.0000%
```
|column|name|description|
|--| -------- | --------|
|1|#Tag|tag sequence|
|2|SpeciesNO|barcode name or unknow|
|3|readCount|reads number|
|4|Pct| percentage|