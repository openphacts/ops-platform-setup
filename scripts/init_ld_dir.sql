-- ConceptWiki
ld_dir('/media/SSD/current_data/CW' , 'pref-mapping-20131212.ttl' , 'http://www.conceptwiki.org' );
ld_dir('/media/SSD/current_data/CW', 'inverted_CW_OCRS_via_CS.ttl' , 'http://www.conceptwiki.org' );
ld_dir('/media/SSD/current_data/CW', 'inverted_CW_ChEMBL_TC_via_Uniprot.ttl', 'http://www.conceptwiki.org');

-- Enzyme
ld_dir('/media/SSD/current_data/enzyme' , 'inference.ttl' , 'http://purl.uniprot.org/enzyme/inference' );
ld_dir('/media/SSD/current_data/enzyme' , 'direct.ttl' , 'http://purl.uniprot.org/enzyme/direct' );
ld_dir('/media/SSD/current_data/enzyme' , 'enzyme_names_comments.ttl' , 'http://purl.uniprot.org/enzyme' );

-- Drugbank
ld_dir('/media/SSD/current_data/drugbank' , 'drugbank_dump.nt' , 'http://linkedlifedata.com/resource/drugbank' );
ld_dir('/media/SSD/current_data/drugbank' , 'drug_type_labels.ttl' , 'http://linkedlifedata.com/resource/drugbank' );
ld_dir('/media/SSD/current_data/drugbank' , 'drug_category_labels.ttl' , 'http://linkedlifedata.com/resource/drugbank' );

-- Uniprot
ld_dir('/media/SSD/current_data/uniprot' , 'swissprot_24052013.rdf.xml' , 'http://purl.uniprot.org' );
ld_dir('/media/SSD/current_data/uniprot' , 'uniparc_24052013.rdf.xml' , 'http://purl.uniprot.org' );
ld_dir('/media/SSD/current_data/uniprot' , 'uniref_24052013.rdf.xml' , 'http://purl.uniprot.org' );

-- ChEBI
ld_dir('/media/SSD/current_data/chebi' , 'chebi_direct.nt' , 'http://www.ebi.ac.uk/chebi/direct' );
ld_dir('/media/SSD/current_data/chebi' , 'chebi_inference.nt' , 'http://www.ebi.ac.uk/chebi/inference' );
ld_dir('/media/SSD/current_data/chebi' , 'chebi.owl' , 'http://www.ebi.ac.uk/chebi' );

-- WikiPathways
ld_dir('/media/SSD/current_data/WP' , 'wpContent_v0.0.69675_20130710.ttl' , 'http://www.wikipathways.org' );

-- Config files
ld_dir('/media/SSD/current_data/api-config-files' , '*.ttl' , 'http://www.openphacts.org/api' );

-- Gene Ontology
ld_dir('/media/SSD/current_data/GO' , 'go_daily-termdb.owl' , 'http://www.geneontology.org' );
ld_dir('/media/SSD/current_data/GO' , 'goTreeInference.ttl', 'http://www.geneontology.org/inference');
ld_dir('/media/SSD/current_data/GO' , 'go_daily-termdb.nt' , 'http://www.geneontology.org/terms' );

-- GOA
ld_dir('/media/SSD/current_data/GOA' , '*.rdf' , 'http://www.openphacts.org/goa' );

-- VoID Dataset Descriptors
ld_dir('/media/SSD/current_data/void' , '*.ttl' , 'http://www.openphacts.org/api/datasetDescriptors' );

-- FDA Adverse Events
ld_dir('/media/SSD/current_data/aers' , 'faers-of-2012-generated-on-2012-07-09.nt', 'http://aers.data2semantics.org/');

-- ChEMBL v16
ld_dir('/media/SSD/current_data/chembl16', '*.ttl', 'http://www.ebi.ac.uk/chembl');

-- Normalised Units and their labels
ld_dir('/media/SSD/current_data/units' , 'ops_units.nt', 'http://www.openphacts.org/units');
ld_dir('/media/SSD/current_data/units' , 'unit_labels.nt', 'http://www.openphacts.org/units');

-- ChEMBL Target Tree
ld_dir('/media/SSD/current_data/target_tree' , 'targetTreeDirect.ttl', 'http://www.ebi.ac.uk/chembl/target/direct');
ld_dir('/media/SSD/current_data/target_tree' , 'targetTreeInference.ttl', 'http://www.ebi.ac.uk/chembl/target/inference');

-- Open PHACTS Chemical Registry
ld_dir('/media/SSD/current_data/OCRS/20131111/CHEMBL' , 'PROPERTIES_CHEMBL20131111.ttl' , 'http://ops.rsc.org' );
ld_dir('/media/SSD/current_data/OCRS/20131111/CHEMBL' , 'SYNONYMS_CHEMBL20131111.ttl' , 'http://ops.rsc.org' );
ld_dir('/media/SSD/current_data/OCRS/20131111/CHEMBL' , 'LINKSET_EXACT_CHEMBL20131111.ttl' , 'http://ops.rsc.org' );
ld_dir('/media/SSD/current_data/OCRS/20131111/CHEBI' , 'PROPERTIES_CHEBI20131111.ttl' , 'http://ops.rsc.org' );
ld_dir('/media/SSD/current_data/OCRS/20131111/CHEBI' , 'SYNONYMS_CHEBI20131111.ttl' , 'http://ops.rsc.org' );
ld_dir('/media/SSD/current_data/OCRS/20131111/CHEBI' , 'LINKSET_EXACT_CHEBI20131111.ttl' , 'http://ops.rsc.org' );
ld_dir('/media/SSD/current_data/OCRS/20131111/DRUGBANK' , 'PROPERTIES_DRUGBANK20131111.ttl' , 'http://ops.rsc.org' );
ld_dir('/media/SSD/current_data/OCRS/20131111/DRUGBANK' , 'LINKSET_EXACT_DRUGBANK20131111.ttl' , 'http://ops.rsc.org' );
ld_dir('/media/SSD/current_data/OCRS/20131111/PDB' , 'PROPERTIES_PDB20131111.ttl' , 'http://ops.rsc.org' );
ld_dir('/media/SSD/current_data/OCRS/20131111/PDB' , 'SYNONYMS_PDB20131111.ttl' , 'http://ops.rsc.org' );
ld_dir('/media/SSD/current_data/OCRS/20131111/MESH' , 'PROPERTIES_MESH20131111.ttl' , 'http://ops.rsc.org' );
ld_dir('/media/SSD/current_data/OCRS/20131111/MESH' , 'SYNONYMS_MESH20131111.ttl' , 'http://ops.rsc.org' );

-- DisGeneT
ld_dir('/media/SSD/current_data/disgenet', '*.ttl', 'http://rdf.imim.es');
ld_dir('/media/SSD/current_data/disgenet', 'sio.owl', 'http://rdf.imim.es');

-- linkedct.org

ld_dir('/media/SSD/current_data/linkedct', 'linkedct-dump-2013-10-01.nt', 'http://linkedct.org');

-- Nextprot

ld_dir('/media/SSD/current_data/nx_np', '*.rdf', 'http://www.nextprot.org');
ld_dir('/media/SSD/current_data/nx_np', '*.nquads', 'http://www.nextprot.org');
