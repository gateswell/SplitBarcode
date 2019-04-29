#step 1
echo ============ start at `date` ==============
perl SplitBarcode.pl -r1 ./test_1.fq.gz -r2 ./test_2.fq.gz -f 101 -b ./bc.list  -c Y -rc N
echo ============ end at `date` ==============
#step 2
sh gzip.main.sh