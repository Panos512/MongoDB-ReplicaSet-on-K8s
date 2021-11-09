#!/bin/bash


var=$(date +"%FORMAT_STRING")
now=$(date +"%Y_%m_%d_%H_%M_%S")

mongodump --config=/etc/mongodump.cfg -oplog --gzip

tar -zcvf $(now).tar.gz dump/ 

s3cmd --config=/etc/s3config.cfg put $(now).tar.gz s3://cms-mongodb-backups/

rm -rf ./*