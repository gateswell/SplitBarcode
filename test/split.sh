echo ============ start at `date` ==============
perl SplitBarcode.pl -r1 ./test_1.fq.gz -r2 ./test_2.fq.gz -f 101 -l 110 -b ./bc.list  -c Y -rc N
echo ============ end at `date` ==============
