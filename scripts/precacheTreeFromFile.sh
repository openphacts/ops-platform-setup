#!/bin/bash

if [ $# -ne 3 -a $# -ne 5 ]
then
	echo 'Usage: precacheTree.sh <tree_name> <format> <server_name>'
	echo 'Usage: precacheTree.sh <tree_name> <format> <server_name> <app_id> <app_key>'
	exit 1
fi

TREE_NAME=$1
FORMAT=$2
SERVER_NAME=$3

if [ $# -eq 5 ]
then
	APP_ID="app_id=$4&"
	APP_KEY="app_key=$5&"
else
	APP_ID=""
	APP_KEY=""
fi


#sanitization
ACCEPTED_TREES=("enzyme" "chembl" "chebi" "go")
found=false
for val in ${ACCEPTED_TREES[*]}; do
	if [ $val == $TREE_NAME ]
	then
		found=true
		break
	fi
done

if [ $found == false ]
then
	echo "Unknown tree name. Possible values: enzyme, chembl, chebi, go"
	exit 1
fi

if [[ "$FORMAT" != "tsv" && "$FORMAT" != "json" ]]
then
	echo 'Unknown format. Possible values: json, tsv'
	exit 1
fi

if [ "$FORMAT" == "json" ]
then
	PAGE_SIZE=50
else #assuming tsv
	PAGE_SIZE=250
fi

COMPOUND_CLASS_PHARMA_API_CALL="http://$SERVER_NAME/compound/tree/pharmacology/pages?${APP_ID}${APP_KEY}_format=$FORMAT&_pageSize=$PAGE_SIZE"
TARGET_CLASS_PHARMA_API_CALL="http://$SERVER_NAME/target/tree/pharmacology/pages?${APP_ID}${APP_KEY}_format=$FORMAT&_pageSize=$PAGE_SIZE"

COMPOUND_CLASS_COUNT_API_CALL="http://$SERVER_NAME/compound/tree/pharmacology/count?${APP_ID}${APP_KEY}_format=tsv&uri="
TARGET_CLASS_COUNT_API_CALL="http://$SERVER_NAME/target/tree/pharmacology/count?${APP_ID}${APP_KEY}_format=tsv&uri="

if [ "$TREE_NAME" == "chebi" ]
then
	COUNT_API_CALL=$COMPOUND_CLASS_COUNT_API_CALL
	PHARMA_API_CALL=$COMPOUND_CLASS_PHARMA_API_CALL
else
	COUNT_API_CALL=$TARGET_CLASS_COUNT_API_CALL
	PHARMA_API_CALL=$TARGET_CLASS_PHARMA_API_CALL
fi

#make the call to get the root elements and store them in the file "elementList"

#exit 0

inputFile="$TREE_NAME""Hierarchy"
echo $inputFile



#for each element in the elementList make do a count API call and then request each page
NON_EMPTY_PAGE_COUNT=0
EMPTY_PAGE_COUNT=0
TOTAL_SIZE=0

while read line
do
	encodedURI=$(php -r "echo urlencode(\"$line\");")
	#echo "$encodedURI"

	FINAL_COUNT_API_CALL="$COUNT_API_CALL$encodedURI"
	RESULT_COUNT=$(curl "$FINAL_COUNT_API_CALL" | tail -1 | cut -f 2 | cut -d ":" -f 2)
	echo "$FINAL_COUNT_API_CALL: $RESULT_COUNT results"

	#compute the number of pages that need to be requested
	if [ "$RESULT_COUNT" -ne 0 ]
	then
		ITERATIONS=$((($RESULT_COUNT+$PAGE_SIZE)/$PAGE_SIZE))
		echo "Iterations $ITERATIONS"
		NON_EMPTY_PAGE_COUNT=$(($NON_EMPTY_PAGE_COUNT+$ITERATIONS))
	else
		ITERATIONS=0
		EMPTY_PAGE_COUNT=$(($EMPTY_PAGE_COUNT+1))
	fi

	if [ "$ITERATIONS" -gt 0 ]
	then
		for PAGE_NO in $(eval echo "{1..$ITERATIONS}")
		do	
			API_CALL_FRAGMENT="&_page=$PAGE_NO&uri="
			FINAL_PHARMA_API_CALL="$PHARMA_API_CALL$API_CALL_FRAGMENT$encodedURI"
		
			echo $FINAL_PHARMA_API_CALL
			curl "$FINAL_PHARMA_API_CALL">pageFile
			FILESIZE=$(stat -c%s "pageFile")
			TOTAL_SIZE=$(($TOTAL_SIZE+$FILESIZE/1024))
		done
	fi
done <$inputFile

echo "Total cached pages: $NON_EMPTY_PAGE_COUNT"
echo "Total classes with no results: $EMPTY_PAGE_COUNT"
echo "Total size cached in KB: $TOTAL_SIZE"



