# SplitBarcode
该脚本只用于拆分MGI平台测序下机的PE数据。  
## Author
作者： caoshuhuan (caoshuhuan@yeah.net)。  
如果对脚本有疑问或者报bug，随时欢迎联系。  
## Version history
当前版本号 v1.0  

v1.0:  
 - 拆分单barcode PE下机数据  
 - 可生成压缩文件  
 - 拆分统计结果（详见下方教程）
v1.1 *(开发中)* :  
 - 支持双barcode拆分
 - 支持拆分SE数据
## Prerequisites, Tutorial and Results
系统要求：`Linux` 
内存：建议**1Gb**以上  
存储：建议**1Tb**以上  
Perl版本：建议5.16及以上  
本脚本在64位CentOS7系统上，使用1Gb内存，在不压缩情况下，拆分100Gb数据大概耗时2小时。  

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
- `*` 必选参数。
- 默认mismatch值为**2**.
- 默认输出到当前目录`./`.
- 默认生成压缩文件，且格式为**.gz**
- 默认以**反向互补**方式拆分
#### Command line example 
```
perl SplitBarcode.pl -r1 read1.fq.gz -r2 read2.fq.gz -e 1 -f 100 -l 110 -b barcode.list -r N -o /path/outdir -c Y
```
请先确认**first cycle number**和**last cycle number**准确  
 
#### barcode list example
barcode名和barcode序列以制表符`tab`或空格`space`分开  
以#开头的行会被忽略，例如：`#96	ATGATCTAGC`.  
```
1	ATGCATCTAA
2	AGCTCTGGAC
```
默认以反向互补的形式拆分，也即Read2序列中的位于first cycle和last cycle内的序列与提供的barcode序列是反向互补关系，如果是正向关系，则设置参数`-rc N`。  
例如：
下述为一条Read2的fastq序列  

```
@V300000000L1C001R001000000/2
TGACTCAATCATACGTTTATACCTCCTATAGTAAAAAGTTTTGTCTTCTTTCAGATATAAGTGTCTCTGTGATGCAGGCTGGGTTGGCATCAACTGTGAATCATTCCAAC
+
FEFGEGGGFGGEEGEFGEEEEBGEFDEEGDBGEGEEAFFGGGDGFEEEEFEFFGFGEFCGDEEFGGEFEEECGBEDEGFFDFFEFEGDGGFFE?EEDCFF71,'962'&)
``` 
该条序列中位于first cycle和last cycle内的序列是**TCATTCCAAC**,  
因此提供的barcode列表中如果barcode为**GTTGGAATGA**或**TCATTCCAAC**时该条序列会被完美拆分出来  

### Output 
运行结束后有以下几类输出结果： 
- barcode_1.fq(.gz), barcode_2.fq(.gz)
- BarcodeStat.txt
- TagStat.txt

#### - barcode fastq
生成的fastq文件名格式为:

> Chipname_lane_barcode_1.fq.gz : ` V300000000_L01_1.fq.gz`  
> Chipname_lane_barcode_2.fq.gz : ` V300000000_L01_2.fq.gz`  

其中Chipname和lane名来源于提供的待拆分文件名。  
当然还有一组`undecoded_1.fq.gz`和`undecoded_2.fq.gz`，用于存储未拆分出来的reads。  

#### - BarcodeStat.txt
BarcodeStat.txt为统计所提供的各个barcode拆分率，最后一行*Total*行统计总共拆分率和reads数。  
BarcodeStat.txt格式为：  
``` 
#SpeciesNO	Correct	Corrected	Total	Pct
1	95327109	4112238	99439347	19.2152%
2	93797238	6267736	100064974	19.3361%
...
Total	468560368	27305422	495865790	95.8187%
```
|column|name|description|
|--| -------- | --------|
|1|SpeciesNO |barcode 名 |
|2|Correct       |容错率为0时拆分的reads数 | 
|3|Corrected |在允许容错率内拆分的reads数|
|4|Total |总拆分reads数 |
|5|Pct|百分率|
#### - TagStat.txt
Tag是位于Read2 first cylce和last cycle之间的序列，和barcode长度一致。该文件统计所有Tag的数目和比率   
TagStat.txt格式为: 
```
#Tag	SpeciesNO	readCount	Pct
ATGCATCTAA	1	99439347	19.2152%
...
ATGATCTAGC	unknow	200	0.0000%
```
|column|name|description|
|--| -------- | --------|
|1|#Tag|tag序列|
|2|SpeciesNO|对应的barcode名或者unknown|
|3|readCount|reads数|
|4|Pct|百分比|