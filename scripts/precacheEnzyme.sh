#!/bin/bash

SERVER_NAME='ops2.few.vu.nl'
PREFIX='http://purl.uniprot.org/enzyme/'
#will be called for all enzyme classes which are not leaves in the tree
ENZYME_HAS_MEMBERS_API_CALL="http://$SERVER_NAME/target/enzyme/members?uri="
#will be called for all enzyme classes except the 6 roots
ENZYME_CLASS_API_CALL="http://$SERVER_NAME/target/enzyme/node?uri="

#query http://purl.uniprot.org/enzyme for all the enzyme classes 
curl 'http://ops2.few.vu.nl:8890/sparql?default-graph-uri=&query=SELECT+DISTINCT+%3Fs+WHERE+%7B%0D%0A%09GRAPH+%3Chttp%3A%2F%2Fpurl.uniprot.org%2Fenzyme%3E+%7B%0D%0A%09%09%3Fs+%3Fp+%3Fo+.%0D%0A%09%7D+%0D%0A%7D++&format=csv' | grep "$PREFIX" | tr -d '"' >enzymeList


cat enzymeList | while read line
do
	encodedURI=$(php -r "echo urlencode(\"$line\");")
	#echo "$encodedURI"
	
	#afterLastPoint=$(echo $line | cut -d '.' -f 6);
	afterLastPoint=$(echo $line | sed "s,$PREFIX,," | cut -d '.' -f 4);
	afterFirstPoint=$(echo $line | sed "s,$PREFIX,," | cut --complement -d '.' -f 1);
	if [ $afterFirstPoint = '-.-.-' ]; then
		API_CALL="$ENZYME_HAS_MEMBERS_API_CALL$encodedURI"
		echo $API_CALL
		curl "$API_CALL"
	elif [ $afterLastPoint = '-' ]; then
		API_CALL="$ENZYME_HAS_MEMBERS_API_CALL$encodedURI"
		echo $API_CALL
		curl "$API_CALL"
		API_CALL="$ENZYME_CLASS_API_CALL$encodedURI"
		curl "$API_CALL"
	else
		API_CALL="$ENZYME_CLASS_API_CALL$encodedURI"
		echo $API_CALL
		curl "$API_CALL"
	fi
done
