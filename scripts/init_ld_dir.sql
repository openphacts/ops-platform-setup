-- ConceptWiki
ld_dir('/media/SSD/current_data/CW' , 'pref-mapping-20131212.ttl' , 'http://www.conceptwiki.org' );
ld_dir('/media/SSD/current_data/CW', 'inverted_CW_OCRS_via_CS.ttl' , 'http://www.conceptwiki.org' );
ld_dir('/media/SSD/current_data/CW', 'inverted_CW_ChEMBL_TC_via_Uniprot.ttl', 'http://www.conceptwiki.org');

-- Enzyme
ld_dir('/media/SSD/current_data/enzyme' , 'enzyme.rdf' , 'http://purl.uniprot.org/enzyme' );

-- DrugBank v4.1
ld_dir('/media/SSD/current_data/drugbank' , 'drugbank.nt' , 'http://www.openphacts.org/bio2rdf/drugbank');

-- Uniprot 2015_11
ld_dir('/media/SSD/current_data/uniprot' , 'swissprot_20151117.rdf.xml' , 'http://purl.uniprot.org' );
ld_dir('/media/SSD/current_data/uniprot' , 'uniparc_20151116.rdf.xml' , 'http://purl.uniprot.org' );
ld_dir('/media/SSD/current_data/uniprot' , 'uniref_20151116.rdf.xml' , 'http://purl.uniprot.org' );

-- ChEBI v125
ld_dir('/media/SSD/current_data/chebi' , 'chebi.owl' , 'http://www.ebi.ac.uk/chebi' );

-- WikiPathways
ld_dir('/media/SSD/current_data/WP' , '*.ttl' , 'http://www.wikipathways.org' );
ld_dir('/media/SSD/current_data/WP/wp/Cow', '*.ttl', 'http://www.wikipathways.org' );
ld_dir('/media/SSD/current_data/WP/wp/Bacillus subtilis', '*.ttl', 'http://www.wikipathways.org' );
ld_dir('/media/SSD/current_data/WP/wp/Arabidopsis thaliana', '*.ttl', 'http://www.wikipathways.org' );
ld_dir('/media/SSD/current_data/WP/wp/Rice', '*.ttl', 'http://www.wikipathways.org' );
ld_dir('/media/SSD/current_data/WP/wp/Fruit fly', '*.ttl', 'http://www.wikipathways.org' );
ld_dir('/media/SSD/current_data/WP/wp/Worm', '*.ttl', 'http://www.wikipathways.org' );
ld_dir('/media/SSD/current_data/WP/wp/Dog', '*.ttl', 'http://www.wikipathways.org' );
ld_dir('/media/SSD/current_data/WP/wp/Chicken', '*.ttl', 'http://www.wikipathways.org' );
ld_dir('/media/SSD/current_data/WP/wp/Escherichia coli', '*.ttl', 'http://www.wikipathways.org' );
ld_dir('/media/SSD/current_data/WP/wp/Mosquito', '*.ttl', 'http://www.wikipathways.org' );
ld_dir('/media/SSD/current_data/WP/wp/Yeast', '*.ttl', 'http://www.wikipathways.org' );
ld_dir('/media/SSD/current_data/WP/wp/Fusarium graminearum', '*.ttl', 'http://www.wikipathways.org' );
ld_dir('/media/SSD/current_data/WP/wp/Maize', '*.ttl', 'http://www.wikipathways.org' );
ld_dir('/media/SSD/current_data/WP/wp/Zebra fish', '*.ttl', 'http://www.wikipathways.org' );
ld_dir('/media/SSD/current_data/WP/wp/Chimpanzee', '*.ttl', 'http://www.wikipathways.org' );
ld_dir('/media/SSD/current_data/WP/wp/Rat', '*.ttl', 'http://www.wikipathways.org' );
ld_dir('/media/SSD/current_data/WP/wp/Human', '*.ttl', 'http://www.wikipathways.org' );
ld_dir('/media/SSD/current_data/WP/wp/Mouse', '*.ttl', 'http://www.wikipathways.org' );
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
ld_dir('/media/SSD/current_data/OCRS/data/ops-rsc-dataset/CHEMBL' , 'PROPERTIES_CHEMBL20151104.ttl' , 'http://ops.rsc.org' );
ld_dir('/media/SSD/current_data/OCRS/data/ops-rsc-dataset/CHEMBL' , 'SYNONYMS_CHEMBL20151104.ttl' , 'http://ops.rsc.org' );
ld_dir('/media/SSD/current_data/OCRS/data/ops-rsc-dataset/CHEMBL' , 'LINKSET_EXACT_CHEMBL20151104.ttl' , 'http://ops.rsc.org' );
ld_dir('/media/SSD/current_data/OCRS/data/ops-rsc-dataset/CHEBI' , 'PROPERTIES_CHEBI20151104.ttl' , 'http://ops.rsc.org' );
ld_dir('/media/SSD/current_data/OCRS/data/ops-rsc-dataset/CHEBI' , 'SYNONYMS_CHEBI20151104.ttl' , 'http://ops.rsc.org' );
ld_dir('/media/SSD/current_data/OCRS/data/ops-rsc-dataset/CHEBI' , 'LINKSET_EXACT_CHEBI20151104.ttl' , 'http://ops.rsc.org' );
ld_dir('/media/SSD/current_data/OCRS/data/ops-rsc-dataset/DRUGBANK' , 'PROPERTIES_DRUGBANK20151104.ttl' , 'http://ops.rsc.org' );
ld_dir('/media/SSD/current_data/OCRS/data/ops-rsc-dataset/DRUGBANK' , 'LINKSET_EXACT_DRUGBANK20151104.ttl' , 'http://ops.rsc.org' );
ld_dir('/media/SSD/current_data/OCRS/data/ops-rsc-dataset/PDB' , 'PROPERTIES_PDB20151104.ttl' , 'http://ops.rsc.org' );
ld_dir('/media/SSD/current_data/OCRS/data/ops-rsc-dataset/PDB' , 'SYNONYMS_PDB20151104.ttl' , 'http://ops.rsc.org' );
ld_dir('/media/SSD/current_data/OCRS/data/ops-rsc-dataset/MESH' , 'PROPERTIES_MESH20151104.ttl' , 'http://ops.rsc.org' );
ld_dir('/media/SSD/current_data/OCRS/data/ops-rsc-dataset/MESH' , 'SYNONYMS_MESH20151104.ttl' , 'http://ops.rsc.org' );

-- DisGeneT
ld_dir('/media/SSD/current_data/disgenet', '*.ttl', 'http://rdf.imim.es');

-- Nextprot
ld_dir('/media/SSD/current_data/nx_np', '*.xml', 'http://www.nextprot.org');
ld_dir('/media/SSD/current_data/nx_np', '*.nq', 'http://www.nextprot.org');

-- Caloha
ld_dir('/media/SSD/current_data/caloha', 'caloha.ttl', 'http://www.nextprot.org/caloha');

-- BioAssayOntology 
--ld_dir('/media/SSD/current_data/BAO', 'bao_complete_bfo_dev.owl', 'http://www.bioassayontology.org');
ld_dir('/media/SSD/current_data/BAO', 'bao_complete_examples.owl', 'http://www.bioassayontology.org');
--ld_dir('/media/SSD/current_data/BAO', 'bao_complete.owl', 'http://www.bioassayontology.org');
ld_dir('/media/SSD/current_data/BAO', 'bao_core.owl', 'http://www.bioassayontology.org');
--ld_dir('/media/SSD/current_data/BAO', 'bao_external.owl', 'http://www.bioassayontology.org');
ld_dir('/media/SSD/current_data/BAO', 'bao_metadata.owl', 'http://www.bioassayontology.org');
ld_dir('/media/SSD/current_data/BAO', 'bao_module_biology.owl', 'http://www.bioassayontology.org');
ld_dir('/media/SSD/current_data/BAO', 'bao_module_properties.owl', 'http://www.bioassayontology.org');
ld_dir('/media/SSD/current_data/BAO', 'bao_module_vocabularies.owl', 'http://www.bioassayontology.org');
ld_dir('/media/SSD/current_data/BAO', 'bao_ro_combinator.owl', 'http://www.bioassayontology.org');
ld_dir('/media/SSD/current_data/BAO', 'bao_vocabulary_assaykit.owl', 'http://www.bioassayontology.org');
ld_dir('/media/SSD/current_data/BAO', 'bao_vocabulary_assay.owl', 'http://www.bioassayontology.org');
ld_dir('/media/SSD/current_data/BAO', 'bao_vocabulary_biology.ttl', 'http://www.bioassayontology.org');
ld_dir('/media/SSD/current_data/BAO', 'bao_vocabulary_computational.owl', 'http://www.bioassayontology.org');
ld_dir('/media/SSD/current_data/BAO', 'bao_vocabulary_detection.owl', 'http://www.bioassayontology.org');
ld_dir('/media/SSD/current_data/BAO', 'bao_vocabulary_format.owl', 'http://www.bioassayontology.org');
ld_dir('/media/SSD/current_data/BAO', 'bao_vocabulary_function.owl', 'http://www.bioassayontology.org');
ld_dir('/media/SSD/current_data/BAO', 'bao_vocabulary_instrument.owl', 'http://www.bioassayontology.org');
ld_dir('/media/SSD/current_data/BAO', 'bao_vocabulary_materialentity.owl', 'http://www.bioassayontology.org');
ld_dir('/media/SSD/current_data/BAO', 'bao_vocabulary_method.owl', 'http://www.bioassayontology.org');
--ld_dir('/media/SSD/current_data/BAO', 'bao_vocabulary_organization.owl', 'http://www.bioassayontology.org');
--ld_dir('/media/SSD/current_data/BAO', 'bao_vocabulary_people.owl', 'http://www.bioassayontology.org');
--ld_dir('/media/SSD/current_data/BAO', 'bao_vocabulary_phenotype.owl', 'http://www.bioassayontology.org');
ld_dir('/media/SSD/current_data/BAO', 'bao_vocabulary_properties.owl', 'http://www.bioassayontology.org');
--ld_dir('/media/SSD/current_data/BAO', 'bao_vocabulary_quality.owl', 'http://www.bioassayontology.org');
ld_dir('/media/SSD/current_data/BAO', 'bao_vocabulary_result.ttl', 'http://www.bioassayontology.org');
--ld_dir('/media/SSD/current_data/BAO', 'bao_vocabulary_role.owl', 'http://www.bioassayontology.org');
ld_dir('/media/SSD/current_data/BAO', 'bao_vocabulary_ro.owl', 'http://www.bioassayontology.org');
ld_dir('/media/SSD/current_data/BAO', 'bao_vocabulary_screenedentity.owl', 'http://www.bioassayontology.org');
--ld_dir('/media/SSD/current_data/BAO', 'bao_vocabulary_software.owl', 'http://www.bioassayontology.org');
ld_dir('/media/SSD/current_data/BAO', 'bao_vocabulary_unit.owl', 'http://www.bioassayontology.org');

-- Disease Ontology
ld_dir('/media/SSD/current_data/DOID','doid.owl',  'http://purl.obolibrary.org/obo/doid');

-- SureCheMBL
ld_dir('/media/SSD/current_data/SureChEMBL', '*.ttl', 'http://www.ebi.ac.uk/surechembl');

-- NCATS
ld_dir('/media/SSD/current_data/NCATS/opdsr/rdf/data', 'npcpd2_*.ttl', 'http://rdf.ncats.nih.gov/opddr');
ld_dir('/media/SSD/current_data/NCATS/opdsr/rdf/data', 'pubchem_pd2_assay.ttl', 'http://rdf.ncats.nih.gov/opddr/pubchem');
