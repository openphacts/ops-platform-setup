-- ConceptWiki
ld_dir('/media/SSD/current_data/CW' , 'pref-mapping-20131212.ttl' , 'http://www.conceptwiki.org' );
ld_dir('/media/SSD/current_data/CW', 'inverted_CW_OCRS_via_CS.ttl' , 'http://www.conceptwiki.org' );
ld_dir('/media/SSD/current_data/CW', 'inverted_CW_ChEMBL_TC_via_Uniprot.ttl', 'http://www.conceptwiki.org');

-- Enzyme
ld_dir('/media/SSD/current_data/enzyme' , 'enzyme.rdf' , 'http://purl.uniprot.org/enzyme' );

-- DrugBank v4.1
ld_dir('/media/SSD/current_data/drugbank' , 'drugbank.nt' , 'http://www.openphacts.org/bio2rdf/drugbank');

-- Uniprot 2015_1
ld_dir('/media/SSD/current_data/uniprot' , 'swissprot_28012015.rdf.xml' , 'http://purl.uniprot.org' );
ld_dir('/media/SSD/current_data/uniprot' , 'uniparc_28012015.rdf.xml' , 'http://purl.uniprot.org' );
ld_dir('/media/SSD/current_data/uniprot' , 'uniref_28012015.rdf.xml' , 'http://purl.uniprot.org' );

-- ChEBI v125
ld_dir('/media/SSD/current_data/chebi' , 'chebi.owl' , 'http://www.ebi.ac.uk/chebi' );

-- WikiPathways
ld_dir('/media/SSD/current_data/WP' , '*.ttl' , 'http://www.wikipathways.org' );
ld_dir('/media/SSD/current_data/WP/WPREACTRDF' , '*.ttl' , 'http://www.wikipathways.org' );
ld_dir('/media/SSD/current_data/WP/OPSWPRDF' , '*.ttl' , 'http://www.wikipathways.org' );

-- Gene Ontology
ld_dir('/media/SSD/current_data/GO' , 'go.owl' , 'http://www.geneontology.org' );

-- GOA
ld_dir('/media/SSD/current_data/GOA' , '*.rdf' , 'http://www.openphacts.org/goa' );

-- VoID Dataset Descriptors
ld_dir('/media/SSD/current_data/void' , '*.ttl' , 'http://www.openphacts.org/api/datasetDescriptors' );

-- FDA Adverse Events
ld_dir('/media/SSD/current_data/aers' , 'faers-of-2012-generated-on-2012-07-09.nt', 'http://aers.data2semantics.org/');

-- ChEMBL v20
ld_dir('/media/SSD/current_data/chembl20', '*.ttl', 'http://www.ebi.ac.uk/chembl');

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

-- Nextprot
ld_dir('/media/SSD/current_data/nx_np', '*.rdf', 'http://www.nextprot.org');
ld_dir('/media/SSD/current_data/nx_np', '*.nquads', 'http://www.nextprot.org');

-- Caloha
ld_dir('/media/SSD/current_data/caloha', 'caloha.ttl', 'http://www.nextprot.org/caloha');

-- BioAssayOntology 
ld_dir('/media/SSD/current_data/BAO', 'bao_complete.owl', 'http://www.bioassayontology.org');
ld_dir('/media/SSD/current_data/BAO', 'bao_vocabulary_biology.ttl', 'http://www.bioassayontology.org');
ld_dir('/media/SSD/current_data/BAO', 'bao_vocabulary_result.ttl', 'http://www.bioassayontology.org');
ld_dir('/media/SSD/current_data/BAO', 'bao_vocabulary_format.owl', 'http://www.bioassayontology.org');
ld_dir('/media/SSD/current_data/BAO', 'bao_vocabulary_method.owl', 'http://www.bioassayontology.org');
ld_dir('/media/SSD/current_data/BAO', 'bao_vocabulary_screenedentity.owl', 'http://www.bioassayontology.org');

-- Disease Ontology
ld_dir('/media/SSD/current_data/DOID','doid.owl',  'http://purl.obolibrary.org/obo/doid');
