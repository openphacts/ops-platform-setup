package org.openphacts.data;

import java.net.URL;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.Set;

import javax.xml.datatype.DatatypeConfigurationException;
import javax.xml.datatype.DatatypeFactory;
import javax.xml.datatype.XMLGregorianCalendar;

import org.openphacts.data.rdf.RdfException;
import org.openphacts.data.rdf.RdfRepository;
import org.openphacts.data.rdf.constants.DctermsConstants;
import org.openphacts.data.rdf.constants.PavConstants;
import org.openphacts.data.rdf.constants.VoidConstants;
import org.openrdf.rio.RDFFormat;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

//TODO: link to previous version

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

	private final Logger logger = LoggerFactory.getLogger(VoidGenerator.class);	
	private RdfRepository repository;
	private String chebiVoidUri;
	private String chebiVersion;
	private String chebi_void_file;
	private Set<String> vocabularies;

	public VoidGenerator(RdfRepository repository) {
		this.repository = repository;
	}

	public String generateVoid(String dataContext, String chebiURL, String baseURI, String creatorURL) 
			throws VoIDException, RdfException {
		try {
			logger.info("Extracting values from ChEBI");
			chebiVersion = getChebiVersion(dataContext);
			XMLGregorianCalendar chebiCreatedDatetime = getChebiCreatedDatetime(dataContext);
			chebi_void_file = baseURI + "/void" + chebiVersion + ".ttl";
			vocabularies = repository.getVocabularies(dataContext);
			logger.info("Loading in base void file");
			String voidContext = importBaseVoidFile(chebi_void_file);
			logger.info("Adding additional metadata using values from downloaded file");
			addMetadataToContext(voidContext, chebiURL, chebiCreatedDatetime, creatorURL);
			logger.info("Creating has_parts linkset");
			createHasPartsLinkset(dataContext, voidContext, baseURI);
			logger.info("Writing VoID descriptor to file");
			String file = writeVoidFile(voidContext);
			logger.info("Removing temporary data");
			repository.removeContext(dataContext);
			repository.removeContext(voidContext);
			return file;
		} finally {
			
		}
	}

	private void addMetadataToContext(String voidContext, String chebiURL, XMLGregorianCalendar chebiCreatedDatetime, String creatorURL) 
			throws RdfException, VoIDException {
		repository.addTripleWithLiteral(chebi_void_file, DctermsConstants.TITLE, 
				CHEBI_VOID_TITLE_START + chebiVersion + CHEBI_VOID_TITLE_END, voidContext);
		repository.addTripleWithLiteral(chebi_void_file, DctermsConstants.DESCRIPTION, 
				CHEBI_VOID_DESC_START + chebiVersion + CHEBI_VOID_DESC_END, voidContext);
		repository.addTripleWithURI(chebi_void_file, PavConstants.CREATED_BY, creatorURL, voidContext);
		repository.addTripleWithLiteral(chebiVoidUri, PavConstants.VERSION, chebiVersion, voidContext);
		repository.addTripleWithURI(chebiVoidUri, VoidConstants.DATA_DUMP, chebiURL, voidContext);
		repository.addTripleWithDateTime(chebiVoidUri, DctermsConstants.CREATED, chebiCreatedDatetime, voidContext);
		repository.addTripleWithDateTime(chebiVoidUri, DctermsConstants.MODIFIED, chebiCreatedDatetime, voidContext);	
		addVocabularies(voidContext);
		//XXX: CreationTime should be last as it uses the current time
		addVoidCreationTime(voidContext);
		logger.debug("ChEBI Version: {}", chebiVersion);
	}

	private void addVoidCreationTime(String voidContext) throws VoIDException,
			RdfException {
		XMLGregorianCalendar currentDateTime = getCurrentDateTime();
		repository.addTripleWithDateTime(chebi_void_file, PavConstants.CREATED_ON, currentDateTime, voidContext);
		repository.addTripleWithDateTime(chebi_void_file, PavConstants.LAST_UPDATED_ON, currentDateTime, voidContext);
	}

	private void addVocabularies(String voidContext) throws RdfException {
		for (String vocabulary : vocabularies) {
			repository.addTripleWithURI(chebiVoidUri, VoidConstants.VOCABULARY, vocabulary, voidContext);
		}
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

	private XMLGregorianCalendar getChebiCreatedDatetime(String dataContext) throws RdfException, VoIDException {
		String query =
				"SELECT ?created " +
				"FROM <" + dataContext + "> " + 
				"WHERE {" +
				"?s <http://purl.org/dc/elements/1.1/date> ?created }";
		logger.info("Retrieving ChEBI created date");
		String datetimeString = repository.getLiteralValueAsString(query, "created");
		logger.debug("Raw ChEBI creation datetime: {}", datetimeString);
		try {
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
			Date date = sdf.parse(datetimeString);
			GregorianCalendar gc = new GregorianCalendar();
			gc.setTimeInMillis(date.getTime());            
			DatatypeFactory datatypeFactory = DatatypeFactory.newInstance();
			XMLGregorianCalendar datetime = 
					datatypeFactory.newXMLGregorianCalendar(gc);
			logger.info("ChEBI creation time: {}.", datetime);
			return datetime;
		} catch (DatatypeConfigurationException e) {
			String message = "Problem generating current datetime.";
			logger.error(message, e);
			throw new VoIDException(message, e);
		} catch (ParseException e) {
			String message = "Problem convertin ChEBI date to XML datetime.";
			logger.error(message, e);
			throw new VoIDException(message, e);
		}
	}

	private String getChebiVersion(String dataContext) throws RdfException {
		String query = 
				"SELECT ?version " +
				"FROM <" + dataContext + "> " + 
				"WHERE {" +
				"?s " +
				"<http://www.w3.org/2002/07/owl#versionIRI> ?version }";
		logger.info("Retrieving ChEBI version number");
		return repository.getLiteralValueAsString(query, "version");
	}

	private String getChebiVoidURI(String context) throws RdfException {
		String query =
				"SELECT ?subjectUri " +
				"FROM <" + context + "> " +
				"WHERE { " +
					"?subjectUri a <http://rdfs.org/ns/void#Dataset>" +
				"}";
		logger.info("Retrieving ChEBI URI");
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

	private void createHasPartsLinkset(String dataContext, String voidContext, String baseURI) 
			throws RdfException {
		String query = 
				"CONSTRUCT { ?source <http://purl.obolibrary.org/obo#has_part> ?target } " +
				"FROM <" + dataContext + "> " +
				"WHERE { " +
				"?source <http://www.w3.org/2000/01/rdf-schema#subClassOf> ?tmp . " +
				"?tmp <http://www.w3.org/2002/07/owl#onProperty> <http://purl.obolibrary.org/obo#has_part> ; " +
				"<http://www.w3.org/2002/07/owl#someValuesFrom> ?target ." +
				"}";
		String fileName = "chebiHasPartsLinkset" + chebiVersion + ".ttl";
		String fileBaseUri = baseURI + "/" + fileName;
		String linksetContext = repository.createNewContext();
		repository.addTripleWithURI(fileBaseUri, VoidConstants.IN_DATASET, 
				chebi_void_file + "#has_partsLinkset", linksetContext);
		repository.createLinkset(query, linksetContext);
		logger.info("Writing to file {}", fileName);
		repository.writeToFile(linksetContext, fileName);
	}

}
