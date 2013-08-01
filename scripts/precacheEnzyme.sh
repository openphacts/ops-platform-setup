#!/bin/bash

SERVER_NAME='ops2.few.vu.nl'
PREFIX='http://purl.uniprot.org/enzyme/'
#will be called for all enzyme classes which are not leaves in the tree
ENZYME_HAS_MEMBERS_API_CALL="http://$SERVER_NAME/target/enzyme/members?uri="
#will be called for all enzyme classes except the 6 roots
ENZYME_CLASS_API_CALL="http://$SERVER_NAME/target/enzyme/node?uri="

PAGE_SIZE=250
FORMAT=tsv
ENZYME_PHARMA_PAGINATED_API_CALL="http://$SERVER_NAME/target/enzyme/pharmacology/pages?_format=$FORMAT&_pageSize=$PAGE_SIZE"
ENZYME_PHARMA_COUNT_API_CALL="http://$SERVER_NAME/target/enzyme/pharmacology/count?_format=tsv&uri="

#query http://purl.uniprot.org/enzyme for all the enzyme classes 
#curl 'http://ops2.few.vu.nl:8890/sparql?default-graph-uri=&query=SELECT+DISTINCT+%3Fs+WHERE+%7B%0D%0A%09GRAPH+%3Chttp%3A%2F%2Fpurl.uniprot.org%2Fenzyme%3E+%7B%0D%0A%09%09%3Fs+%3Fp+%3Fo+.%0D%0A%09%7D+%0D%0A%7D+#+&format=csv' | grep "$PREFIX" | tr -d '"' >enzymeList

echo "http://purl.uniprot.org/enzyme/1.-.-.-
http://purl.uniprot.org/enzyme/2.-.-.-
http://purl.uniprot.org/enzyme/3.-.-.-
http://purl.uniprot.org/enzyme/4.-.-.-
http://purl.uniprot.org/enzyme/5.-.-.-
http://purl.uniprot.org/enzyme/6.-.-.-" >enzymeList

#get the enzyme subclasses from the graph enzyme direct
curl "http://$SERVER_NAME:8890/sparql?default-graph-uri=&query=PREFIX+rdfs%3A+<http%3A%2F%2Fwww.w3.org%2F2000%2F01%2Frdf-schema%23>%0D%0ASELECT+DISTINCT+%3Fs+WHERE+%7B%0D%0A%09GRAPH+<http%3A%2F%2Fpurl.uniprot.org%2Fenzyme%2Fdirect>+%7B%0D%0A%09%09%3Fs+rdfs%3AsubClassOf+%3Fo+.%0D%0A%09%7D+%0D%0A%7D&format=csv" | tr -d '"' | grep $PREFIX  >>enzymeList

NON_EMPTY_PAGE_COUNT=0
EMPTY_PAGE_COUNT=0
while read line
do
	encodedURI=$(php -r "echo urlencode(\"$line\");")
	#echo "$encodedURI"
	
	#afterLastPoint=$(echo $line | cut -d '.' -f 6);
	#afterLastPoint=$(echo $line | sed "s,$PREFIX,," | cut -d '.' -f 4);
	#afterFirstPoint=$(echo $line | sed "s,$PREFIX,," | cut --complement -d '.' -f 1);
	#if [ $afterFirstPoint = '-.-.-' ]; then
	#	API_CALL="$ENZYME_HAS_MEMBERS_API_CALL$encodedURI"
	#	echo $API_CALL
	#	
	#elif [ $afterLastPoint = '-' ]; then
	#	API_CALL="$ENZYME_HAS_MEMBERS_API_CALL$encodedURI"
	#	echo $API_CALL
	#	curl "$API_CALL"
	#	API_CALL="$ENZYME_CLASS_API_CALL$encodedURI"
	#	curl "$API_CALL"
	#else
	#	API_CALL="$ENZYME_CLASS_API_CALL$encodedURI"
	#	echo $API_CALL
	#	curl "$API_CALL"
	#fi

	COUNT_API_CALL="$ENZYME_PHARMA_COUNT_API_CALL$encodedURI"
	RESULT_COUNT=$(curl "$COUNT_API_CALL" | tail -1 | cut -f 2)
	if [ $RESULT_COUNT != 0 ]
	then
		ITERATIONS=$((($RESULT_COUNT+$PAGE_SIZE)/$PAGE_SIZE))
		#echo "Iterations $ITERATIONS"
		NON_EMPTY_PAGE_COUNT=$(($NON_EMPTY_PAGE_COUNT+$ITERATIONS))
	else
		ITERATIONS=0
		EMPTY_PAGE_COUNT=$(($EMPTY_PAGE_COUNT+1))
	fi

	for PAGE_NO in $(eval echo "{1..$ITERATIONS}")
	do
		API_CALL_FRAGMENT="&_page=$PAGE_NO&uri="
		PHARMA_API_CALL="$ENZYME_PHARMA_PAGINATED_API_CALL$API_CALL_FRAGMENT$encodedURI"
		
		echo $PHARMA_API_CALL
		curl "$PHARMA_API_CALL"
	done
done <enzymeList

echo "Total cached pages: $NON_EMPTY_PAGE_COUNT"
echo "Total enzymes with no results: $EMPTY_PAGE_COUNT"



