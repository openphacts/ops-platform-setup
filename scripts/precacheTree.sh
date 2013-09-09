#!/bin/bash

SERVER_NAME='ops2.few.vu.nl'

declare -A PREFIX
PREFIX[enzyme]='http://purl.uniprot.org/enzyme/'
PREFIX[chembl]='http://rdf.ebi.ac.uk/resource/chembl/protclass/'
PREFIX[chebi]='http://purl.obolibrary.org/obo/'
PREFIX[go]='http://purl.org/obo/owl/'

#will be called for all enzyme classes which are not leaves in the tree
#ENZYME_HAS_MEMBERS_API_CALL="http://$SERVER_NAME/target/enzyme/members?uri="
#will be called for all enzyme classes except the 6 roots
#ENZYME_CLASS_API_CALL="http://$SERVER_NAME/target/enzyme/node?uri="

PAGE_SIZE=250
FORMAT=tsv
COMPOUND_CLASS_PHARMA_API_CALL="http://$SERVER_NAME/compound/tree/pharmacology/pages?_format=$FORMAT&_pageSize=$PAGE_SIZE"
TARGET_CLASS_PHARMA_API_CALL="http://$SERVER_NAME/target/tree/pharmacology/pages?_format=$FORMAT&_pageSize=$PAGE_SIZE"

COMPOUND_CLASS_COUNT_API_CALL="http://$SERVER_NAME/compound/tree/pharmacology/count?_format=tsv&uri="
TARGET_CLASS_COUNT_API_CALL="http://$SERVER_NAME/target/tree/pharmacology/count?_format=tsv&uri="

if [ "$1" == "chebi" ]
then
	COUNT_API_CALL=$COMPOUND_CLASS_COUNT_API_CALL
	PHARMA_API_CALL=$COMPOUND_CLASS_PHARMA_API_CALL
else
	COUNT_API_CALL=$TARGET_CLASS_COUNT_API_CALL
	PHARMA_API_CALL=$TARGET_CLASS_PHARMA_API_CALL
fi

#ENZYME_PHARMA_PAGINATED_API_CALL="http://$SERVER_NAME/target/enzyme/pharmacology/pages?_format=$FORMAT&_pageSize=$PAGE_SIZE"
#ENZYME_PHARMA_COUNT_API_CALL="http://$SERVER_NAME/target/enzyme/pharmacology/count?_format=tsv&uri="

#query http://purl.uniprot.org/enzyme for all the enzyme classes 
#curl 'http://ops2.few.vu.nl:8890/sparql?default-graph-uri=&query=SELECT+DISTINCT+%3Fs+WHERE+%7B%0D%0A%09GRAPH+%3Chttp%3A%2F%2Fpurl.uniprot.org%2Fenzyme%3E+%7B%0D%0A%09%09%3Fs+%3Fp+%3Fo+.%0D%0A%09%7D+%0D%0A%7D+#+&format=csv' | grep "$PREFIX" | tr -d '"' >elementList


curl "http://$SERVER_NAME/tree?root=$TREE_SHORT_NAME&_format=json" | grep -o -E "rootNode\":\[?{.*}\]?" | grep -o -e "\"_about\":\"[^\"]*\"" | cut -d ':' -f 1 --complement | tr -d '\"' >elementList

#declare an associative array between short names and graph names
declare -A graphMappings
graphMappings[enzyme]="http://purl.uniprot.org/enzyme/direct"
graphMappings[chembl]="http://www.ebi.ac.uk/chembl/target/direct"
graphMappings[chebi]="http://www.ebi.ac.uk/chebi/direct"
graphMappings[go]="http://www.geneontology.org"

#get the tree subclasses from the direct graph 
encodedGraph=$(php -r "echo urlencode(\"${graphMappings[$1]}\");")
echo "Encoded Graph: $encodedGraph"
curl "http://$SERVER_NAME:8890/sparql?default-graph-uri=&query=PREFIX+rdfs%3A+<http%3A%2F%2Fwww.w3.org%2F2000%2F01%2Frdf-schema%23>%0D%0ASELECT+DISTINCT+%3Fs+WHERE+%7B%0D%0A%09GRAPH+<$encodedGraph>+%7B%0D%0A%09%09%3Fs+rdfs%3AsubClassOf+%3Fo+.%0D%0A%09%7D+%0D%0A%7D&format=csv" | tr -d '"' | grep ${PREFIX[$1]}  >>elementList



NON_EMPTY_PAGE_COUNT=0
EMPTY_PAGE_COUNT=0
while read line
do
	encodedURI=$(php -r "echo urlencode(\"$line\");")
	#echo "$encodedURI"

	FINAL_COUNT_API_CALL="$COUNT_API_CALL$encodedURI"
	echo "Final Count: $FINAL_COUNT_API_CALL"
	RESULT_COUNT=$(curl "$FINAL_COUNT_API_CALL" | tail -1 | cut -f 3)
	echo "Result Count: $RESULT_COUNT"

	if [ $RESULT_COUNT != 0 ]
	then
		ITERATIONS=$((($RESULT_COUNT+$PAGE_SIZE)/$PAGE_SIZE))
		echo "Iterations $ITERATIONS"
		NON_EMPTY_PAGE_COUNT=$(($NON_EMPTY_PAGE_COUNT+$ITERATIONS))
	else
		ITERATIONS=0
		EMPTY_PAGE_COUNT=$(($EMPTY_PAGE_COUNT+1))
	fi

	for PAGE_NO in $(eval echo "{1..$ITERATIONS}")
	do
		API_CALL_FRAGMENT="&_page=$PAGE_NO&uri="
		FINAL_PHARMA_API_CALL="$PHARMA_API_CALL$API_CALL_FRAGMENT$encodedURI"
		
		echo $FINAL_PHARMA_API_CALL
		#curl "$FINAL_PHARMA_API_CALL"
	done
done <elementList

echo "Total cached pages: $NON_EMPTY_PAGE_COUNT"
echo "Total classes with no results: $EMPTY_PAGE_COUNT"



