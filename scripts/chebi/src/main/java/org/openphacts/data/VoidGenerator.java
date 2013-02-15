package org.openphacts.data;

import java.net.URL;
import java.util.GregorianCalendar;

import javax.xml.datatype.DatatypeConfigurationException;
import javax.xml.datatype.DatatypeFactory;
import javax.xml.datatype.XMLGregorianCalendar;

import org.openphacts.data.rdf.RdfException;
import org.openphacts.data.rdf.RdfRepository;
import org.openphacts.data.rdf.constants.DctermsConstants;
import org.openphacts.data.rdf.constants.PavConstants;
import org.openphacts.data.rdf.constants.VoidConstants;
import org.openrdf.model.Value;
import org.openrdf.query.BindingSet;
import org.openrdf.query.QueryEvaluationException;
import org.openrdf.query.TupleQueryResult;
import org.openrdf.rio.RDFFormat;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class VoidGenerator {

	private static final String CHEBI_VOID_IN = "chebi_void.in.ttl";
	private static final String CHEBI_VOID_TITLE_START = 
			"ChEBI ";
	private static final String CHEBI_VOID_TITLE_END =
			" VoID Description";
	private static final String CHEBI_VOID_DESC_START =	
			"The VoID description for the ChEBI ";
	private static final String CHEBI_VOID_DESC_END = " Ontology.";
	private static final String CHEBI_BASEURI = "http://purl.obolibrary.org/obo/";

//	<>
//	pav:createdBy <%%SCRIPT_RUNNER%%> ;
//  :chebi
//	dcterms:created "%%CHEBI_DATETIME%%"^^xsd:dateTime;
//	dcterms:modified "%%CHEBI_DATETIME%%"^^xsd:dateTime;

	
	private final Logger logger = LoggerFactory.getLogger(VoidGenerator.class);	
	private RdfRepository repository;
	private String chebiVoidUri;
	private String chebiVersion;
	private String chebi_void_baseuri;

	public VoidGenerator(RdfRepository repository) {
		this.repository = repository;
	}

	public String generateVoid(String dataContext, String chebiURL) throws VoIDException, RdfException {
		try {
			logger.info("Retrieving ChEBI version number");
			chebiVersion = getChebiVersion(dataContext);
//			String chebiCreatedDatetime = getChebiCreatedDatetime(dataContext);
			chebi_void_baseuri = CHEBI_BASEURI + "void" + chebiVersion + ".ttl";
			logger.info("Loading in base void file");
			String voidContext = importBaseVoidFile(chebi_void_baseuri);
			logger.info("Adding additional metadata using values from downloaded file");
			addMetadataToContext(voidContext, chebiURL);
			logger.info("Writing VoID descriptor to file");
			String file = writeVoidFile(voidContext);
			logger.info("Removing temporary data");
			repository.removeContext(dataContext);
			repository.removeContext(voidContext);
			return file;
		} finally {
			
		}
	}

	private void addMetadataToContext(String voidContext, String chebiURL) 
			throws RdfException, VoIDException {
		repository.addTripleWithLiteral(chebi_void_baseuri, DctermsConstants.TITLE, 
				CHEBI_VOID_TITLE_START + chebiVersion + CHEBI_VOID_TITLE_END, voidContext);
		repository.addTripleWithLiteral(chebi_void_baseuri, DctermsConstants.DESCRIPTION, 
				CHEBI_VOID_DESC_START + chebiVersion + CHEBI_VOID_DESC_END, voidContext);
		repository.addTripleWithLiteral(chebiVoidUri, PavConstants.VERSION, chebiVersion, voidContext);
		repository.addTripleWithURI(chebiVoidUri, VoidConstants.DATA_DUMP, chebiURL, voidContext);
		XMLGregorianCalendar currentDateTime = getCurrentDateTime();
		repository.addTripleWithDateTime(chebi_void_baseuri, PavConstants.CREATED_ON, currentDateTime, voidContext);
		repository.addTripleWithDateTime(chebi_void_baseuri, PavConstants.LAST_UPDATED_ON, currentDateTime, voidContext);
		logger.debug("ChEBI Version: {}", chebiVersion);
	}

	private XMLGregorianCalendar getCurrentDateTime() throws VoIDException {
		try {
			GregorianCalendar gregorianCalendar = new GregorianCalendar();
			DatatypeFactory datatypeFactory = DatatypeFactory.newInstance();
			XMLGregorianCalendar now = 
					datatypeFactory.newXMLGregorianCalendar(gregorianCalendar);
			logger.info("Timestamp that will be applied: {}.", now);
			return now;
		} catch (DatatypeConfigurationException e) {
			String message = "Problem generating current datetime.";
			logger.error(message, e);
			throw new VoIDException(message, e);
		}
	}
//
//	private XMLGregorianCalendar getChebiCreatedDatetime(String dataContext) {
//		String query =
//				"SELECT ?created " +
//				"FROM <" + dataContext + "> " + 
//				"WHERE {" +
//				"?s " +
//				"<http://purl.org/dc/elements/1.1/#date> ?created }";
//		return repository.getDatetimeValue(query);
//	}

	private String getChebiVersion(String dataContext) throws RdfException {
		String query = 
				"SELECT ?s ?version " +
				"FROM <" + dataContext + "> " + 
				"WHERE {" +
				"?s " +
				"<http://www.w3.org/2002/07/owl#versionIRI> ?version }";
		return repository.getLiteralValueAsString(query, "version");
	}

	private String getChebiVoidURI(String context) throws RdfException {
		String query =
				"SELECT ?subjectUri " +
				"FROM <" + context + "> " +
				"WHERE { " +
					"?subjectUri a <http://rdfs.org/ns/void#Dataset>" +
				"}";
		return repository.getLiteralValueAsString(query, "subjectUri");
	}

	private String importBaseVoidFile(String baseuri) throws RdfException {
		URL file = this.getClass().getResource("/" + CHEBI_VOID_IN);
		logger.debug("Import base void file from {}", file.getPath());
		String context = repository.loadRdf(file, baseuri, RDFFormat.TURTLE);
		logger.info("ChEBI VoID Context: {}", context);
		chebiVoidUri = getChebiVoidURI(context);
		return context;
	}

	private String writeVoidFile(String voidContext) throws RdfException {
		String fileName = "chebiVoid" + chebiVersion + ".ttl";
		logger.debug("Writing to file {}", fileName);
		repository.writeToFile(voidContext, fileName);
		return fileName;
	}

}