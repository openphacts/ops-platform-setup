#!/bin/bash

function retrieve_file()
{
    echo -n "Retrieving ChEBI file ..."
    curl -f -O $1
    if [[ $? = 0 ]]; then
	echo "Success!"
    else
	echo "Failure!"
	exit 1
    fi
}

if [ $# -ne 1 ]
then
    echo "Usage: `basename $0` <URL>"
    echo "You must specify the location of the ChEBI OWL file"
    exit 1
fi

retrieve_file $1
