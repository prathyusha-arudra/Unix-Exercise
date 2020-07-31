#!/bin/bash

# Takes Input
time=$1

# Extracts the year from the Input
year="${time:0:4}"

# Extracts the month from the Input
mon="${time:4:2}"

# Extracts the date from the Input
date="${time:6:2}"


datetime="$year-$mon-$date"

# Converts month into %b
mod=$(date -jf %F $datetime '+%Y-%-b-%-d')
#echo $mod

# Converts the date into epoch timestamp
hours=$(date -j -f '%Y-%b-%d' $mod "+%s")
#echo $hours

declare -a my_array

echo hours bids	impressions wins clicks >> 1530947027582_out.csv


for i in {0..23}
do
	
	
	bids=$(cat $2 | awk '/bids/{f=1;next} /impression/{f=0} f' | awk '{if($1 >= $((hours+(i*60))) && $1 < $((hours+((i+1)*60)-1))) {sum += $2}} END {print sum}')

	# Handles empty fields
	if [ ! -n "$bids" ] ; then
  		bids=0
	fi ;

	impressions=$(cat $2 | awk '/impression/{f=1;next} /wins/{f=0} f' | awk '{if($1 >= $((hours+(i*60))) && $1 < $((hours+((i+1)*60)-1))) {sum += $2}} END {print sum}')

	# Handles empty fields
	if [ ! -n "$impressions" ] ; then
  		impressions=0
	fi ;

	wins=$(cat $2 | awk '/wins/{f=1;next} /click/{f=0} f' | awk '{if($1 >= $((hours+(i*60))) && $1 < $((hours+((i+1)*60)-1))) {sum += $2}} END {print sum}')

	# Handles empty fields
	if [ ! -n "$wins" ] ; then
  		wins=0
	fi ;

	clicks=$(cat $2 | awk '/click/{f=1;next}  f' | awk '{if($1 >= $((hours+(i*60))) && $1 < $((hours+((i+1)*60)-1))) {sum += $2}} END {print sum}')

	# Handles empty fields
	if [ ! -n "$clicks" ] ; then
  		clicks=0
	fi ;

	my_array=($((hours+(i*60))) $bids $impressions $wins $clicks) 
	echo ${my_array[*]} | column -t -x

done >> 1530947027582_out.csv