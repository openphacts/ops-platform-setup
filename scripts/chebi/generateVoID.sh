#!/bin/bash

CMDS="roqet awk tr"
 
for i in $CMDS
do
        # command -v will return >0 when the $i is not found
	command -v $i >/dev/null && continue || { echo "$i command not found and required by script."; exit 1; }
done

RETRIEVED_FILE="chebiRetrieved.owl"
VOID_TEMPLATE="chebi_void.ttl.in"
VOID_OUTPUT_BASE="chebi_void"
VOID_OUTPUT_FILEEXTENSION=".ttl"

#SCRIPT_RUNNER should become a set-able parameter
SCRIPT_RUNNER="https://orcid.org/0000-0002-5711-4872"

# %%CHEBI_VERSION%%
# %%CHEBI_DATETIME%%
# %%CHEBI_DATADUMP%%

# %%SCRIPT_RUNTIME%%
# %%SCRIPT_RUNNER%%

CHEBI_VERSION_QUERY="chebi_version_query.rq"

##TODO: Extract vocabulary list from owl file!
##TODO: Link to previous version (probably needs to be a parameter)

function retrieve_file()
{
    echo "Retrieving ChEBI file ..."
    curl -f $1 > $RETRIEVED_FILE
    if [[ $? = 0 ]]; then
	echo "Success!"
    else
	echo "Failure!"
	exit 1
    fi
}

function run_query()
{
    query=$1
    output=$2
    roqet -r json -D $RETRIEVED_FILE $query > $output
}

function extract_CHEBI_Version() 
{
    query="SELECT ?version WHERE { <http://purl.obolibrary.org/obo> <http://www.w3.org/2002/07/owl#versionIRI> ?version }"
    run_query $CHEBI_VERSION_QUERY "version.out"
    CHEBI_VERSION=`awk -F"[,:]" '{for(i=1;i<=NF;i++){if($i~/value\042/){print $(i+1)}}}' "version.out" | tr -d ' ' | tr -d '"'`
    rm "version.out"
}

function extract_parameters()
{
    extract_CHEBI_Version
    #CHEBI_VERSION=1
    CHEBI_DATETIME="2013-01-25T00:00:00Z"
    CHEBI_DATADUMP=$1 
}

function write_void()
{
    echo "ChEBI Version: $CHEBI_VERSION"
    echo $CHEBI_DATETIME
    echo $CHEBI_DATADUMP
    echo $SCRIPT_RUNNER
    VOID_OUTPUT_FILENAME="$VOID_OUTPUT_BASE$CHEBI_VERSION$VOID_OUTPUT_FILEEXTENSION"
    SCRIPT_RUNTIME=$(date -u +"%Y-%m-%dT%TZ")
    sed -e "s,%%CHEBI_VERSION%%,$CHEBI_VERSION,g" -e "s,%%CHEBI_DATETIME%%,$CHEBI_DATETIME,g" -e "s,%%CHEBI_DATADUMP%%,$CHEBI_DATADUMP,g" -e "s,%%SCRIPT_RUNNER%%,$SCRIPT_RUNNER,g" -e "s,%%SCRIPT_RUNTIME%%,$SCRIPT_RUNTIME,g" $VOID_TEMPLATE > $VOID_OUTPUT_FILENAME
}

if [ $# -ne 1 ]
then
    echo "Usage: `basename $0` <URL>"
    echo "You must specify the location of the ChEBI OWL file"
    exit 1
fi

retrieve_file $1
extract_parameters $1
write_void
rm $RETRIEVED_FILE
echo "Successfully generated $VOID_OUTPUT_FILENAME corresponding to ChEBI version $CHEBI_VERSION."
exit 0
