-- ConceptWiki
ld_dir('/media/SSD/current_data' , 'cw_url_preflabels_20120620_validTurtle.ttl' , 'http://www.conceptwiki.org' );
ld_dir('/media/SSD/current_data' , 'CW_ChemSpider.ttl' , 'http://www.conceptwiki.org' );
ld_dir('/media/SSD/current_data/CW' , '*.ttl' , 'http://www.conceptwiki.org' );


-- Enzyme
ld_dir('/media/SSD/current_data' , 'inference.ttl' , 'http://purl.uniprot.org/enzyme/inference' );
ld_dir('/media/SSD/current_data' , 'direct.ttl' , 'http://purl.uniprot.org/enzyme/direct' );
ld_dir('/media/SSD/current_data' , 'enzyme_names_comments.ttl' , 'http://purl.uniprot.org/enzyme' );

-- Drugbank
ld_dir('/media/SSD/current_data' , 'drugbank_dump.nt' , 'http://linkedlifedata.com/resource/drugbank' );
ld_dir('/media/SSD/current_data' , 'drug_type_labels.ttl' , 'http://linkedlifedata.com/resource/drugbank' );
ld_dir('/media/SSD/current_data' , 'drug_category_labels.ttl' , 'http://linkedlifedata.com/resource/drugbank' );

-- ChEMBL v13
--ld_dir('/media/SSD/current_data' , 'activities.nt' , 'http://data.kasabi.com/dataset/chembl-rdf' );
--ld_dir('/media/SSD/current_data' , 'activities_qudt.nt' , 'http://data.kasabi.com/dataset/chembl-rdf' );
--ld_dir('/media/SSD/current_data' , 'assays.nt' , 'http://data.kasabi.com/dataset/chembl-rdf' );
--ld_dir('/media/SSD/current_data' , 'compounds.nt' , 'http://data.kasabi.com/dataset/chembl-rdf' );
--ld_dir('/media/SSD/current_data' , 'docs.nt' , 'http://data.kasabi.com/dataset/chembl-rdf' );
--ld_dir('/media/SSD/current_data' , 'targets.nt' , 'http://data.kasabi.com/dataset/chembl-rdf' );
--ld_dir('/media/SSD/current_data' , 'chemspider_match.nt' , 'http://data.kasabi.com/dataset/chembl-rdf' );
--ld_dir('/media/SSD/current_data' , 'compounds_props.nt' , 'http://data.kasabi.com/dataset/chembl-rdf' );
--ld_dir('/media/SSD/current_data' , 'compounds_chebi.nt' , 'http://data.kasabi.com/dataset/chembl-rdf' );
--ld_dir('/media/SSD/current_data' , 'act_qudt_act.nt' , 'http://data.kasabi.com/dataset/chembl-rdf' );
--ld_dir('/media/SSD/current_data' , 'act_qudt_ic50.nt' , 'http://data.kasabi.com/dataset/chembl-rdf' );
--ld_dir('/media/SSD/current_data' , 'act_qudt_inhib.nt' , 'http://data.kasabi.com/dataset/chembl-rdf' );
--ld_dir('/media/SSD/current_data' , 'act_qudt_pot.nt' , 'http://data.kasabi.com/dataset/chembl-rdf' );
--ld_dir('/media/SSD/current_data' , 'act_qudt_types.nt' , 'http://data.kasabi.com/dataset/chembl-rdf' );

-- Uniprot
ld_dir('/media/SSD/current_data' , 'swissprot_24052013.rdf.xml' , 'http://purl.uniprot.org' );
ld_dir('/media/SSD/current_data' , 'uniparc_24052013.rdf.xml' , 'http://purl.uniprot.org' );
ld_dir('/media/SSD/current_data' , 'uniref_24052013.rdf.xml' , 'http://purl.uniprot.org' );

-- ChEBI
ld_dir('/media/SSD/current_data' , 'chebi_direct.nt' , 'http://www.ebi.ac.uk/chebi/direct' );
ld_dir('/media/SSD/current_data' , 'chebi_inference.ttl' , 'http://www.ebi.ac.uk/chebi/inference' );
ld_dir('/media/SSD/current_data' , 'chebi_class_labels.nt' , 'http://www.ebi.ac.uk/chebi' );

-- ChemSpider
--ld_dir('/media/SSD/current_data' , 'PROPERTIES_ChEMBL20120731.ttl' , 'http://www.chemspider.com' );
--ld_dir('/media/SSD/current_data' , 'SYNONYMS_ChEMBL20120731.ttl' , 'http://www.chemspider.com' );
--ld_dir('/media/SSD/current_data/linksets_dev' , 'LINKSET_EXACT_DRUGBANK20130408.ttl' , 'http://www.chemspider.com' );
--ld_dir('/media/SSD/current_data/linksets_dev' , 'LINKSET_EXACT_CHEBI20130408.ttl' , 'http://www.chemspider.com' );
--ld_dir('/media/SSD/current_data/linksets_dev' , 'LINKSET_EXACT_CHEMBL20130408.ttl' , 'http://www.chemspider.com' );
--ld_dir('/media/SSD/current_data' , 'PROPERTIES_DrugBank20120731.ttl' , 'http://www.chemspider.com' );
--ld_dir('/media/SSD/current_data' , 'PROPERTIES_MeSH20120731.ttl' , 'http://www.chemspider.com' );
--ld_dir('/media/SSD/current_data' , 'PROPERTIES_ChEBI20120731.ttl' , 'http://www.chemspider.com' );
--ld_dir('/media/SSD/current_data' , 'PROPERTIES_PDB20120731.ttl' , 'http://www.chemspider.com' );
--ld_dir('/media/SSD/current_data' , 'SYNONYMS_MeSH20120731.ttl' , 'http://www.chemspider.com' );
--ld_dir('/media/SSD/current_data' , 'SYNONYMS_ChEBI20120731.ttl' , 'http://www.chemspider.com' );
--ld_dir('/media/SSD/current_data' , 'SYNONYMS_PDB20120731.ttl' , 'http://www.chemspider.com' );

-- WikiPathways
ld_dir('/media/SSD/current_data' , 'wpContent_v0.0.69675_20130710.ttl' , 'http://www.wikipathways.org' );

-- Text Mining
--ld_dir('/media/SSD/current_data/pubmed_subset_rdf_doc/pubmed_subset' , '*.n3' , 'http://www.ubo.textmining.org' );
--ld_dir('/media/SSD/current_data/pubmed_subset_rdf_DrugBank_V1/pubmed_subset' , '*.n3' , 'http://www.ubo.textmining.org' );
--ld_dir('/media/SSD/current_data/pubmed_subset_rdf_Genes_HomoSapiens_V1/pubmed_subset' , '*.n3' , 'http://www.ubo.textmining.org' );
--ld_dir('/media/SSD/current_data/pubmed_subset_rdf_MeSHDisease_V1/pubmed_subset' , '*.n3' , 'http://www.ubo.textmining.org' );
--ld_dir('/media/SSD/current_data/pubmed_subset_rdf_peregrine/pubmed_subset' , '*.n3' , 'http://www.ubo.textmining.org' );
--ld_dir('/media/SSD/current_data/pubmed_subset_rdf_peregrine_dict' , '*.n3' , 'http://www.ubo.textmining.org' );
--ld_dir('/media/SSD/current_data/pubmed_subset_rdf_pm_dict' , '*.n3' , 'http://www.ubo.textmining.org' );
--ld_dir('/media/SSD/current_data/pubmed_subset_rdf_Taxonomy_NCBI_V1/pubmed_subset' , '*.n3' , 'http://www.ubo.textmining.org' );

-- Config files
ld_dir('/media/SSD/current_data/api-config-files' , '*.ttl' , 'http://www.openphacts.org/api' );

-- Gene Ontology
ld_dir('/media/SSD/current_data' , 'go_daily-termdb.owl' , 'http://www.geneontology.org' );
ld_dir('/media/SSD/current_data' , 'go_daily-termdb.nt' , 'http://www.geneontology.org/terms' );

-- GOA
ld_dir('/media/SSD/current_data/GOA' , '*.rdf' , 'http://www.openphacts.org/goa' );

-- VoID Dataset Descriptors
ld_dir('/media/SSD/current_data/void' , '*.ttl' , 'http://www.openphacts.org/api/datasetDescriptors' );

-- Commercial Data
--ld_dir('/media/SSD/current_data' , 'gvk_data.nt', 'http://www.openphacts.org/gvk' );
--ld_dir('/media/SSD/current_data' , 'tr_data.nt', 'http://www.openphacts.org/tr' );

-- FDA Adverse Events
ld_dir('/media/SSD/current_data' , 'faers-of-2012-generated-on-2012-07-09.nt', 'http://aers.data2semantics.org/');

-- ChEMBL v16
ld_dir('/media/SSD/current_data/chembl16', '*.ttl', 'http://www.ebi.ac.uk/chembl');

-- Units and labels for ChEMBL v13
--ld_dir('/media/SSD/current_data' , 'ops_units.nt', 'http://www.openphacts.org/units');
--ld_dir('/media/SSD/current_data' , 'unit_labels.nt', 'http://www.openphacts.org/units');

-- ChEMBL Target Tree
ld_dir('/media/SSD/current_data/target_tree' , 'targetTreeDirect.ttl', 'http://www.ebi.ac.uk/chembl/target/direct');
ld_dir('/media/SSD/current_data/target_tree' , 'targetTreeInference.ttl', 'http://www.ebi.ac.uk/chembl/target/inference');

-- Open PHACTS Chemical Registry
ld_dir('/media/SSD/current_data/OPCR/20130724/CHEMBL' , 'PROPERTIES_CHEMBL20130724.ttl' , 'http://ops.rsc-us.org' );
ld_dir('/media/SSD/current_data/OPCR/20130724/CHEMBL' , 'SYNONYMS_CHEMBL20130724.ttl' , 'http://ops.rsc-us.org' );
ld_dir('/media/SSD/current_data/OPCR/20130724/CHEMBL' , 'LINKSET_EXACT_CHEMBL20130724.ttl' , 'http://ops.rsc-us.org' );
ld_dir('/media/SSD/current_data/OPCR/20130724/CHEBI' , 'PROPERTIES_CHEBI20130724.ttl' , 'http://ops.rsc-us.org' );
ld_dir('/media/SSD/current_data/OPCR/20130724/CHEBI' , 'SYNONYMS_CHEBI20130724.ttl' , 'http://ops.rsc-us.org' );
ld_dir('/media/SSD/current_data/OPCR/20130724/CHEBI' , 'LINKSET_EXACT_CHEBI20130724.ttl' , 'http://ops.rsc-us.org' );
ld_dir('/media/SSD/current_data/OPCR/20130724/DRUGBANK' , 'PROPERTIES_DRUGBANK20130724.ttl' , 'http://ops.rsc-us.org' );
ld_dir('/media/SSD/current_data/OPCR/20130724/DRUGBANK' , 'LINKSET_EXACT_DRUGBANK20130724.ttl' , 'http://ops.rsc-us.org' );
ld_dir('/media/SSD/current_data/OPCR/20130724/PDB' , 'PROPERTIES_PDB20130724.ttl' , 'http://ops.rsc-us.org' );
ld_dir('/media/SSD/current_data/OPCR/20130724/PDB' , 'SYNONYMS_PDB20130724.ttl' , 'http://ops.rsc-us.org' );
ld_dir('/media/SSD/current_data/OPCR/20130724/MESH' , 'PROPERTIES_MESH20130724.ttl' , 'http://ops.rsc-us.org' );
ld_dir('/media/SSD/current_data/OPCR/20130724/MESH' , 'SYNONYMS_MESH20130724.ttl' , 'http://ops.rsc-us.org' );
