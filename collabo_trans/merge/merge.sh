#!/usr/bin/bash

## Set filepath variables

md_path="../"
list="./md_list.txt"    # translated md files list by order of chapter
tmp="/tmp/tempfile.md"  # temporary file (remove at the end )
output="./md_merge1.md" # output file name 

## Initialize files to use 
cat /dev/null  > $tmp
cat /dev/null  > $output


## read and concatenate translated md files into one file
for line in `cat $list`
do
   cat ${md_path}${line}| \
	  grep -E -e '^<' -e '^> ' -e '^$'| \
	  sed -E '/^$/d'\
          >> $tmp
   echo "done"
done

## read each line from the concatenated file, and recover to XLIFF tags and so on 

i=0

while read line
do
  #echo "count" $i" : "$line
  m=$(($i % 4))
  if [ $m -eq  0 ];then
     echo $line |sed -E 's/^> /<trans-unit id="/'|sed -E 's/$/" xml:space="preserve">/' >> $output
  elif [ $m -eq  1 ];then
     echo $line |sed -E 's/^> /<source xml:lang="en">/'|sed -E 's/$/<\/source>/' >> $output
  elif [ $m -eq 3 ];then
     echo $line |sed -E 's/^/<target xml:lang="ja" state="translated">/'|sed -E 's/$/<\/target>/' >> $output
  else 
     echo "do nothing" > /dev/null  # Delete machine translation
  fi 
  i=`expr $i + 1`

done < $tmp 

rm $tmp

exit
