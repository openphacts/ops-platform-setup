#!/bin/bash
# <> pav:createdBy <http://orcid.org/0000-0002-5711-4872> .
# <> pav:contributor <https://github.com/andrawaag/> . 

BASE_URI="<>"

INPUT_VOID_FILE=hgnc_void.ttl.in
OUTPUT_VOID_FILE=/tmp/hgncVoid.ttl
OUTPUT_LINKSET_FILE=/tmp/hgncLinksets.ttl

write_void() {
    cp $INPUT_VOID_FILE $OUTPUT_VOID_FILE
    echo "<> pav:lastUpdateOn $SCRIPT_RUNTIME ." >> $OUTPUT_VOID_FILE
    echo ":hgncDataset dct:issued $SCRIPT_RUNTIME ." >> $OUTPUT_VOID_FILE
    echo ":hgncId-SymbolLinkset dct:issued $SCRIPT_RUNTIME ." >> $OUTPUT_VOID_FILE
}

extract_links() {
    echo "@prefix skos: <http://www.w3.org/2004/02/skos/core#> ." > $OUTPUT_LINKSET_FILE
    echo "@prefix void: <http://rdfs.org/ns/void#> ." >> $OUTPUT_LINKSET_FILE
    echo "@prefix hgnc: <$HGNC_VOID_FILE> ." >> $OUTPUT_LINKSET_FILE
    echo "$BASE_URI void:inDataset hgnc:hgncId-SymbolLinkset" >> $OUTPUT_LINKSET_FILE
    curl "http://www.genenames.org/cgi-bin/hgnc_downloads?col=gd_hgnc_id&col=gd_app_sym&status=Approved&status_opt=2&where=&order_by=gd_hgnc_id&format=text&limit=&hgnc_dbtag=on&submit=submit" |cut -f2 -d:| awk '{print "<http://identifiers.org/hgnc/"$1 "> skos:exactMatch <http://identifiers.org/hgnc.symbol/"$2"> ."
'} >> $OUTPUT_LINKSET_FILE
}

SCRIPT_RUNTIME="\""$(date +"%Y-%m-%dT%T%z")"\"^^xsd:dateTime"
write_void
extract_links
