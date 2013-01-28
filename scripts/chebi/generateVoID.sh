#!/bin/bash

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

##TODO: Extract vocabulary list from owl file!

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

function extract_parameters()
{
    CHEBI_VERSION=1
    CHEBI_DATETIME="2013-01-25T00:00:00Z"
    CHEBI_DATADUMP=$1 
}

function write_void()
{
    echo $CHEBI_VERSION
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
