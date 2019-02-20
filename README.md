# SplitBarcode
The repository provides scripts for spliting PE fastq from MGI sequencer platform by barcodes sequence. 
## Author
The current implementation was written by caoshuhuan (caoshuhuan@yeah.net).
send email to me if you have any question about this script, I feel appeciate when you report bug to me !
## Version history
The current code is v1.0
v1.1 *(under deverlopment)* :
 - support dual barcodes split
## Prerequisites, Tutorial and Results
The script runs on `CentOS 7` or other linux systems on a **64Bit** machine with `Perl 5.26`, for **100Gb** data, It will take about **2 hours** with **1 Gb** memory.
 
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
		 -o  --outdir <string>		output directory [default: ./]
		 -h  --help			print help information and exit
```
- `*` means parameter must be provided.
- the default mismatch value is 2.
- the default output directory is `./`.
#### Command line example 
```
perl splitBarcode_PE.pl -r1 read1.fq.gz -r2 read2.fq.gz -e 1 -f 100 -l 110 -b barcode.list -o /path/outdir
```
Please make sure the **first cycle number** and **last cycle number** of barcode correctly.
#### barcode list example
Only barcode name and  barcode sequence need, seperated by `tab` or `space`.  barcode will miss if lane starts with `#`, for example: `#96	ATGATCTAGC`.
```
1	ATGCATCTAA
2	AGCTCTGGAC
```
### Output 
There are several types of file generated after script finished：
- barcode_1.fq, barcode_2.fq
- BarcodeStat.txt
- TagStat.txt

#### - barcode fastq
The format of fastq name is:
> Chipname_lane_barcode_1.fq : ` V300000000_L01_1.fq`
> Chipname_lane_barcode_2.fq : ` V300000000_L01_2.fq`

Chip name and lane name are captured from the read1.fq.gz.
Also there is a couple of fastq named `ambiguous_1.fq` and `ambiguous_2.fq`, to keep reads which don't contain any barcode sequence.
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
|1|SpeciesNO |bacode name |
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