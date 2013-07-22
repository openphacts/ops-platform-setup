BASE_URI="<>"
LINKSET_URI=":HGNC_ID-HGNC_Symbol-Linkset"
OUTPUT_FILE=/tmp/hgncLinksets.ttl

#write_void() {

#}

extract_links() {
    echo "@prefix skos: <http://www.w3.org/2004/02/skos/core#> ." > $OUTPUT_FILE
    echo "@prefix void: <http://rdfs.org/ns/void#> ." >> $OUTPUT_FILE
    echo "$BASE_URI void:inDataset $LINKSET_URI" >> $OUTPUT_FILE
    curl "http://www.genenames.org/cgi-bin/hgnc_downloads?col=gd_hgnc_id&col=gd_app_sym&status=Approved&status_opt=2&where=&order_by=gd_hgnc_id&format=text&limit=&hgnc_dbtag=on&submit=submit" |cut -f2 -d:| awk '{print "<http://identifiers.org/hgnc/"$1 "> skos:exactMatch <http://identifiers.org/hgnc.symbol/"$2"> ."
'} >> $OUTPUT_FILE
}

extract_links