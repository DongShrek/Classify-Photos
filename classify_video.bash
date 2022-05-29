#!/bin/bash

# This script is used to sort photos by date and 
# move them to the folder with the corresponding date, 
# and record the MD5 hash of the photos

# Get the names of all files
files=`find . -maxdepth 1 -type f ! -name "*.md5"` 

for photo in $files
do
# Get the extensions of all files
filename_extension=${photo##*.} 
 # Filter out the required image files
if [ $filename_extension == "MOV" ] ;then

# 获取文件修改时间的时间戳
file_timestamp=`stat -c %Y $photo`
echo "时间戳 $file_timestamp"

# 将时间戳转成日期格式
dir_data=`date "+%Y-%m-%d" -d @$file_timestamp`
echo  "文件 $photo 日期 $dir_data"

# Get MD5 hash value
`md5sum $photo>>$dir_data.md5`

# Make photo read-only
`chmod 444 $photo`

# Create folders with the names of the dates photos were taken and move the files with the corresponding date into it
[ -d $dir_data ] || mkdir $dir_data 
[ -d $dir_data ] && mv $photo $dir_data

fi
done 

# Merge all MD5 files
`cat *.md5 > photos_md5.md5`

# md5sum -c photos_md5.md5 (Command to verify MD5 integrity)
