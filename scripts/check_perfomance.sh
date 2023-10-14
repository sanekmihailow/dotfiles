#!/usr/bin/env bash

#check disk
echo -e "\n\n----------- FIO DISK test started -----------\n\n" > ./test_result.txt
fio --randrepeat=1 --ioengine=libaio --direct=1 --gtod_reduce=1 --name=fiotest --filename=testfio --bs=4k --iodepth=64 --size=8G --readwrite=randrw --rwmixread=75 --max-jobs=1 >> ./test_result.txt
rm testfio

echo -e "\n\n----------- ioping disk test started -----------\n\n" >> ./test_result.txt
ioping -c 20 /tmp/ >> ./test_result.txt

echo -e "\n\n----------- Sysbench disk test started -----------\n\n" >> ./test_result.txt
sysbench --num-threads=1 --test=fileio --file-total-size=3G --file-test-mode=rndrw prepare
sysbench --num-threads=1 --test=fileio --file-total-size=3G --file-test-mode=rndrw run >> ./test_result.txt
sysbench --num-threads=1 --test=fileio --file-total-size=3G --file-test-mode=rndrw cleanup


# check ram
echo -e "\n\n----------- sysbench RAM test started -----------\n\n" >> ./test_result.txt
sysbench --threads=1 --events=10000 --test=memory --memory-block-size=8K --memory-total-size=100G --memory-access-mode=seq run >> ./test_result.txt


#check CPU
echo -e "\n\n----------- sysbench CPU test started -----------\n\n" >> ./test_result.txt
sysbench --test=cpu --cpu-max-prime=20000 --num-threads=1 run >> ./test_result.txt


#ckeck all
echo -e "\n\n----------- nench test started -----------\n\n" >> ./test_result.txt
wget http://wget.racing/nench.sh && 
bash nench.sh >> ./test_result.txt
