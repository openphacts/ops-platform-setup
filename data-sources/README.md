Data Loaded by the platform
===================================

This directory should eventually contain void descriptions of each data source used by the platform, which can then be automatically obtained by the platform. In the mean-time, we hope to keep this file up-to-date. Sections are data source.

## ConceptWiki

Graph URI: <http://www.conceptwiki.org>

- cw_prefLabels.ttl
	* http://downloads.nbiceng.net/linksets/20131212-linksets.tgz
	* Added cw and skos prefixes.
	* 3024385 triples

### inverted_CW_OCRS_via_CS.ttl (20131212)

    wget http://openphacts.cs.man.ac.uk:9091/Transitive/Transitive290and382.ttl
    wget http://openphacts.cs.man.ac.uk:9091/Transitive/Transitive290and396.ttl
    wget http://openphacts.cs.man.ac.uk:9091/Transitive/Transitive300and382.ttl
    wget http://openphacts.cs.man.ac.uk:9091/Transitive/Transitive300and396.ttl
    wget http://openphacts.cs.man.ac.uk:9091/Transitive/Transitive308and390.ttl
    wget http://openphacts.cs.man.ac.uk:9091/Transitive/Transitive308and400.ttl
    wget http://openphacts.cs.man.ac.uk:9091/Transitive/Transitive310and382.ttl
    wget http://openphacts.cs.man.ac.uk:9091/Transitive/Transitive310and396.ttl
    wget http://openphacts.cs.man.ac.uk:9091/Transitive/Transitive320and382.ttl
    wget http://openphacts.cs.man.ac.uk:9091/Transitive/Transitive320and396.ttl
    wget http://openphacts.cs.man.ac.uk:9091/Transitive/Transitive330and382.ttl
    wget http://openphacts.cs.man.ac.uk:9091/Transitive/Transitive330and396.ttl
    cat *.ttl > ocrs_cw.tmp
    rapper -i turtle ocrs_cw.tmp -o ntriples | grep exactMatch | sed 's,\(^[[:print:]]*\) \([[:print:]]*\) \([[:print:]]*\) ,\3 \2 \1 ,' > inverted_CW_OCRS_via_CS.ttl
    rm ocrs_cw.tmp

* 1352641 triples

### inverted_CW_ChEMBL_TC_via_Uniprot.ttl (20131212)

    
    wget http://openphacts.cs.man.ac.uk:9091/Transitive/Transitive415and424.ttl
    rapper -i turtle Transitive415and424.ttl -o ntriples | grep exactMatch > inverted_CW_ChEMBL_TC_via_Uniprot.ttl
    rm chembl_cw.tmp

* 11179 triples
 
## Uniprot on 28012015, release 2015_1

    curl -d 'query=reviewed%3ayes&force=yes&format=rdf' http://www.uniprot.org/uniprot/ > swissprot_24052013.rdf.xml
    curl -d 'query=reviewed%3ayes&force=yes&format=rdf' http://www.uniprot.org/uniparc/ > uniparc_24052013.rdf.xml
    curl -d 'sort=&desc=&query=reviewed%3ayes&fil=&format=rdf&force=yes' http://www.uniprot.org/uniref/ > uniref_24052013.rdf.xml

Graph URI: <http://purl.uniprot.org>

- swissprot_28012015.rdf.xml (261071139 triples)
- uniparc_28012015.rdf.xml (518254270 triples)
- uniref_28012015.rdf.xml (477586860 triples)
- TOTAL: 979928936 triples

## Enzyme

Obtained by downloading from <ftp://ftp.uniprot.org/pub/databases/uniprot/current_release/rdf/enzyme.rdf.gz> on 02022015, release 2015_1)

- enzyme.rdf

	Graph URI: <http://purl.uniprot.org/enzyme>

- direct.ttl 

	Graph URI: <http://purl.uniprot.org/enzyme/direct>

	generated using the query: 
	
		INSERT {
     		GRAPH <http://purl.uniprot.org/enzyme/direct> {
     			?subclass <http://www.w3.org/2000/01/rdf-schema#subClassOf> ?superclass
     		}	
     	}
     	WHERE {
     		GRAPH <http://purl.uniprot.org/enzyme> {
     			?subclass <http://www.w3.org/2000/01/rdf-schema#subClassOf> ?superclass 
     		}
     	}
     			

- inference.ttl 

	Graph URI: <http://purl.uniprot.org/enzyme/inference>

	Generated using the query:

		INSERT {
     		GRAPH <http://purl.uniprot.org/enzyme/inference> {
     			?subclass <http://www.w3.org/2000/01/rdf-schema#subClassOf> ?superclass .
     			?subclass <http://www.w3.org/2000/01/rdf-schema#subClassOf> ?subclass .
     		}
     	}
     	WHERE {
     		GRAPH <http://purl.uniprot.org/enzyme/direct> {
			?subclass <http://www.w3.org/2000/01/rdf-schema#subClassOf>+ ?superclass ;
				[] []
     		}
     	}

## Drugbank

Obtained by converting http://www.drugbank.ca/system/downloads/current/drugbank.xml.zip (version 4.1) using https://github.com/bio2rdf/bio2rdf-scripts/blob/master/drugbank/drugbank.php on 19 Feb 2015

Graph URI: <http://www.openphacts.org/bio2rdf/drugbank>

- drugbank.nt 

## Chembl 20

Obtained by downloading all the files from <ftp://ftp.ebi.ac.uk/pub/databases/chembl/ChEMBL-RDF/20.0/> on 18 Feb 2015 

Graph URI <http://www.ebi.ac.uk/chembl>
- cco.ttl
- chembl_20.0_activity.ttl
- chembl_20.0_assay.ttl
- chembl_20.0_bindingsite.ttl
- chembl_20.0_biocmpt.ttl
- chembl_20.0_cellline.ttl
- chembl_20.0_document.ttl
- chembl_20.0_journal.ttl
- chembl_20.0_moa.ttl
- chembl_20.0_molecule.ttl
- chembl_20.0_molecule_chebi_ls.ttl
- chembl_20.0_molhierarchy.ttl
- chembl_20.0_protclass.ttl
- chembl_20.0_source.ttl
- chembl_20.0_target.ttl
- chembl_20.0_target_targetcmpt_ls.ttl
- chembl_20.0_targetcmpt.ttl
- chembl_20.0_targetcmpt_uniprot_ls.ttl
- chembl_20.0_targetrel.ttl
- chembl_20.0_unichem.ttl
- void.ttl 

Replaced Enzyme prefixes in from <http://identifiers.org/ec-code/*> to <http://purl.uniprot.org/enzyme/*> 
NOTE: still needed for target tree pharmacology, investigating whether that like can be obtained from uniprot directly.


     PREFIX cco: <http://rdf.ebi.ac.uk/terms/chembl#>
     INSERT {
     	GRAPH <http://www.ebi.ac.uk/chembl> {
     		?chembl_uri cco:targetCmptXref ?enzyme_uri . 
     		?enzyme_uri a cco:EnzymeClassRef .
     	}
     }
     WHERE {
     	GRAPH <http://www.ebi.ac.uk/chembl> {
     		?chembl_uri cco:targetCmptXref ?ec_uri . 
     		?ec_uri a cco:EnzymeClassRef ;
     			rdfs:label ?label .
     		BIND(IRI(CONCAT('http://purl.uniprot.org/enzyme/', STRAFTER(STR(?ec_uri), 'http://identifiers.org/ec-code/'))) AS ?enzyme_uri )
     	}
     } 

Created activity types and unit URIs:

     INSERT {
     	GRAPH <http://www.ebi.ac.uk/chembl>  {
     		?type_uri rdfs:subClassOf ?act_type ;
     			rdfs:label ?standard_type ;
     		<http://rdf.ebi.ac.uk/terms/chembl#hasQUDT>  ?qudt_uri .
     			?qudt_uri rdfs:label ?standard_unit .
     	}
     }
     WHERE {
     	GRAPH <http://www.ebi.ac.uk/chembl>  {
     		?act <http://rdf.ebi.ac.uk/terms/chembl#standardType> ?standard_type  ;
     			<http://rdf.ebi.ac.uk/terms/chembl#standardUnits> ?standard_unit ;
     			<http://rdf.ebi.ac.uk/terms/chembl#hasQUDT> ?qudt_uri ;
     			a ?act_type .
     		BIND( IRI (CONCAT("http://www.openphacts.org/terms/chembl#", ENCODE_FOR_URI(?standard_type))) AS ?type_uri)
     	}
     }  

ChEMBL 20 Protein Classification

Graph URI <http://www.ebi.ac.uk/chembl/target/direct>

     PREFIX chembl_protclass: <http://rdf.ebi.ac.uk/resource/chembl/protclass/>
     INSERT {
     	GRAPH <http://www.ebi.ac.uk/chembl/target/direct> {
     		?subclass rdfs:subClassOf ?superclass .
     	}
     }
     WHERE {
     	GRAPH <http://www.ebi.ac.uk/chembl>  {
     		?subclass rdfs:subClassOf ?superclass ;
     			rdfs:subClassOf* chembl_protclass:CHEMBL_PC_0 .
     	}
     }
     
Graph URI <http://www.ebi.ac.uk/chembl/target/inference>
     
     INSERT { 
     	GRAPH <http://www.ebi.ac.uk/chembl/target/inference> {
     		?subclass rdfs:subClassOf ?superclass 
     	}
     }
     WHERE {
         GRAPH <http://www.ebi.ac.uk/chembl/target/direct> {
             ?subclass rdfs:subClassOf* ?superclass ;
             	rdfs:subClassOf [] 
         }
     }
    
ISSUE: multiple labels (1 per matching TC) for each enzyme class like:

     <http://identifiers.org/ec-code/2.-.-.-> rdfs:label "CHEMBL_TC_5268 EC Reference: 2.-.-.-"

## Chebi

Obtained from <ftp://ftp.ebi.ac.uk/pub/databases/chebi/ontology/chebi.owl> on 04 Mar 2015 (Chebi Release 125)

- chebi.owl

	Graph URI: <http://www.ebi.ac.uk/chebi>

	Graph URI: <http://www.ebi.ac.uk/chebi/direct>

	Generated by loading chebi.owl and running:

	    INSERT { 
	    	GRAPH <http://www.ebi.ac.uk/chebi/direct> {
	    		?subclass rdfs:subClassOf ?superclass 
	    	}
	    }
	    WHERE {
	    	GRAPH <http://www.ebi.ac.uk/chebi> {
	    		?subclass rdfs:subClassOf ?superclass 
	    		FILTER (!isBlank(?superclass) && ?superclass != owl:Thing)
	    	}
	    }

	Graph URI: <http://www.ebi.ac.uk/chebi/inference>

	Generated by running:

	    INSERT { 
	    	GRAPH <http://www.ebi.ac.uk/chebi/inference> {
	    		?subclass rdfs:subClassOf ?superclass 
	    	}
	    }
	    WHERE {
	    	GRAPH <http://www.ebi.ac.uk/chebi/direct> {
	    		?subclass rdfs:subClassOf* ?superclass ;
	    			[] [] 
	    	}
	    }

## Openphacts Chemistry Registration Service data

Downloaded from: ftp://ftp.rsc-us.org/OPS/20131111/ 

Graph URI: <http://ops.rsc-us.org>
- PROPERTIES_CHEMBL20131111ttl
- SYNONYMS_CHEMBL20131111.ttl
- LINKSET_EXACT_CHEMBL20131111.ttl
- PROPERTIES_CHEBI20131111.ttl
- SYNONYMS_CHEBI20131111.ttl
- LINKSET_EXACT_CHEBI20131111.ttl
- PROPERTIES_DRUGBANK20131111.ttl
- LINKSET_EXACT_DRUGBANK20131111.ttl
- PROPERTIES_PDB20131111.ttl
- SYNONYMS_PDB20131111.ttl
- PROPERTIES_MESH20131111.ttl
- SYNONYMS_MESH20131111.ttl

## FDA Adverse Events

- http://aers.data2semantics.org/data/dump-of-2012-generated-on-2012-07-09.nt.gz

## GO

Downloaded from http://purl.obolibrary.org/obo/go.owl on 04 Mar 2015

- go.owl 

	Graph URI: <http://www.geneontology.org>

	Graph URI: <http://www.geneontology.org/inference>
	
	Generated by running: 
	
	    PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
	    INSERT {
	      GRAPH <http://www.geneontology.org/inference> {
	     	?s rdfs:subClassOf ?o
	      }
	    }
	    WHERE {
  	      GRAPH <http://www.geneontology.org> {
    	        ?s rdfs:subClassOf* ?o ;
	            [] [] .
	          FILTER (!isBlank(?o))
	      }
	    }

## GOA 

Downloaded source from : http://geneontology.org/gene-associations/ on 17 Feb 2015

Generated RDF using https://github.com/openphacts/ops-platform-setup/blob/1.4.9/scripts/goa/goatordf.py on 17 Feb 2015 (finished on 26 Feb 2015)

Graph URI : http://www.openphacts.org/goa

## Wikipathways

Downloaded from : http://rdf.wikipathways.org/ on March 20 2015 (v20150312)

Outstanding issue : https://github.com/openphacts/GLOBAL/issues/210

Graph URI : http://www.wikipathways.org

## DisGeNet

Propriatory version with OMIM data

Downloaded on 31 Mar 2015, v2.1.0, generated on 2014-05-08

Graph URI : http://rdf.imim.es

Generated Association type labels by : 

	    PREFIX sio: <http://semanticscience.org/resource/>
	    PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
	    INSERT {
	    	GRAPH <http://rdf.imim.es> {
	    		sio:SIO_001119 rdfs:label "gene-disease association linked with causal mutation" .
	    		sio:SIO_001120 rdfs:label "therapeutic gene-disease association" .
	    		sio:SIO_001121 rdfs:label "gene-disease biomarker association" .
	    		sio:SIO_001122 rdfs:label "gene-disease association linked with genetic variation" .
	    		sio:SIO_001123 rdfs:label "gene-disease association linked with altered gene expression" .
	    		sio:SIO_001124 rdfs:label "gene-disease association linked with post-translational modification" .
	    	}
	    }
	    WHERE { }
	    
## Nextprot

Downloaded all NextProt nanopubs from http://nanopub-server.ops.labs.vu.nl/ on 08 Apr. 2015

*Issue:* Nextprot protein & tissue URIs not in IMS

*Issue:* Nanopubs use different tissue URIs to CALOHA

*Issue:* Less assertions than 1.4

*Issue:* non-existent EFO code in wasDerivedFrom

Reverted to 1.4 version (Feb 2014)

Graph URI : http://www.nextprot.org

## Caloha

Downloaded from :
ftp://ftp.nextprot.org/pub/current_release/controlled_vocabularies/caloha.obo
on 08 Apr. 2015 .

Converted to RDF using WebProtege.

Reverted to 1.4 version (Jan 2014) to correspond to nextprot

Graph URI : http://www.nextprot.org/caloha
