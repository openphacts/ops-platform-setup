OUTPUT_FILE=/tmp/hgncLinksets.ttl

extract_links() {
    curl "http://www.genenames.org/cgi-bin/hgnc_downloads?col=gd_hgnc_id&col=gd_app_sym&status=Approved&status_opt=2&where=&order_by=gd_hgnc_id&format=text&limit=&hgnc_dbtag=on&submit=submit" |cut -f2 -d:| awk '{print "<http://identifiers.org/hgnc/"$1 "> <http://www.w3.org/2004/02/skos/core#exactMatch> <http://identifiers.org/hgnc.symbol/"$2">"
'} > $OUTPUT_FILE 
}

extract_links