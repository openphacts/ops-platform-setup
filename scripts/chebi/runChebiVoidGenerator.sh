 #!/bin/bash

CHEBI_URI="ftp://ftp.ebi.ac.uk/pub/databases/chebi/ontology/chebi.owl"
BASEURI="http://www.openphacts.org/void"
CREATOR_URI="https://orcid.org/0000-0002-5711-4872"

java -jar target/chebi-0.0.1-SNAPSHOT.one-jar.jar $CHEBI_URI $BASEURI $CREATOR_URI

