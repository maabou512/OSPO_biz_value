#!/usr/bin/bash

md_path="../"
list="./md_list.txt"
tmp="/tmp/tempfile.md"
output="./md_merge1.md"
cat /dev/null  > $tmp
cat /dev/null  > $output

for line in `cat $list`
do
   cat ${md_path}${line}| \
	  grep -E -e '^<' -e '^> ' -e '^$'| \
	  sed -E '/^$/d'\
          >> $tmp
   echo "done"
done

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
     echo "do nothing" > /dev/null
  fi 
  i=`expr $i + 1`

done < $tmp 

rm $tmp

exit

#cat $tmp|sed  -E 's/$/\n$/g' >  $output
cat $tmp|awk 'NR%4!=1'|sed -i -E 's/^/ <source xml:lang="en">/g' > 
#cat $tmp|awk 'NR%4!=3'  > $output #Remove Machine translation ( 4n+1 th line) 
