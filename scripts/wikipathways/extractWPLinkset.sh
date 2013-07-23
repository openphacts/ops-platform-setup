#!/bin/bash
# <> pav:createdBy <http://orcid.org/0000-0002-5711-4872> .
# <> pav:contributor <https://github.com/andrawaag/> . 

BASE_URI="<>"

INPUT_VOID_FILE=wp_void.ttl.in
OUTPUT_VOID_FILE=/tmp/wpVoid.ttl
OUTPUT_LINKSET_FILE=/tmp/wp-po_Linkset.ttl

write_void() {
    cp $INPUT_VOID_FILE $OUTPUT_VOID_FILE
    echo "<> pav:lastUpdateOn $SCRIPT_RUNTIME ." >> $OUTPUT_VOID_FILE
    echo ":wp-poLinkset dct:issued $SCRIPT_RUNTIME ." >> $OUTPUT_VOID_FILE
}

extract_links() {
    echo "@prefix void:    <http://rdfs.org/ns/void#> ." > $OUTPUT_LINKSET_FILE
    echo "@prefix wprdf: <http://rdf.wikipathways.org/> ." >> $OUTPUT_LINKSET_FILE
    curl "http://sparql.wikipathways.org/?default-graph-uri=&query=CONSTRUCT+%7B%3FwpIdentifier+skos%3ArelatedMatch+%3FpathwayOntology+.%7D+%0D%0AWHERE+%7B%0D%0A++%3Fpathway+wp%3ApathwayOntology+%3FpathwayOntology+.%0D%0A++%3Fpathway+dc%3Aidentifier+%3FwpIdentifier+.%0D%0A++FILTER+regex%28%3FpathwayOntology%2C+%22PW_%22%2C+%22i%22%29+%0D%0A%7D&format=text%2Frdf%2Bn3&timeout=0&debug=on" >> $OUTPUT_LINKSET_FILE
    echo >> $OUTPUT_LINKSET_FILE
    echo "$BASE_URI void:inDataset wprdf:wp-poLinkset" >> $OUTPUT_LINKSET_FILE
}

SCRIPT_RUNTIME="\""$(date +"%Y-%m-%dT%T%z")"\"^^xsd:dateTime"
write_void
extract_links
