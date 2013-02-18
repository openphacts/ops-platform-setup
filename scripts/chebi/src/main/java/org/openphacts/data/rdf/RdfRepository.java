package org.openphacts.data.rdf;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.URL;
import java.util.HashSet;
import java.util.Set;

import javax.xml.datatype.XMLGregorianCalendar;

import org.openrdf.model.Literal;
import org.openrdf.model.Resource;
import org.openrdf.model.URI;
import org.openrdf.model.Value;
import org.openrdf.model.ValueFactory;
import org.openrdf.model.impl.URIImpl;
import org.openrdf.query.BindingSet;
import org.openrdf.query.MalformedQueryException;
import org.openrdf.query.QueryEvaluationException;
import org.openrdf.query.QueryLanguage;
import org.openrdf.query.TupleQuery;
import org.openrdf.query.TupleQueryResult;
import org.openrdf.repository.Repository;
import org.openrdf.repository.RepositoryConnection;
import org.openrdf.repository.RepositoryException;
import org.openrdf.repository.sail.SailRepository;
import org.openrdf.sail.memory.MemoryStore;
import org.openrdf.sail.nativerdf.NativeStore;
import org.openrdf.rio.RDFFormat;
import org.openrdf.rio.RDFHandlerException;
import org.openrdf.rio.RDFParseException;
import org.openrdf.rio.RDFWriter;
import org.openrdf.rio.Rio;
import org.openrdf.rio.UnsupportedRDFormatException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class RdfRepository {

	private final Logger logger = LoggerFactory.getLogger(RdfRepository.class);	
	private Repository repository  =
			new SailRepository(new NativeStore(new File("rdf")));
//			new SailRepository(new MemoryStore());

	private static final String BASEURI = "http://www.openphacts.org/";
	
	public RdfRepository() {		
		try {
			repository.initialize();
		} catch (RepositoryException ex) {
			logger.error("Error initializing Repository. {}", ex);
		}
	}
	
	private RepositoryConnection getConnection() throws RdfException{
		try {
			RepositoryConnection connection =  repository.getConnection();
			return connection;
		} catch (RepositoryException ex) {
			logger.error("Unable to get connection. {}", ex);
			throw new RdfException("Unable to establish a connection.");
		}
	}
	
	public String loadRdf(URL file, String baseURI, RDFFormat format) throws RdfException {
		try {
			RepositoryConnection connection = getConnection();
			Resource context = getNewContext();
			connection.add(file, baseURI, format, context);
			logger.debug("empty after data load: {}", connection.isEmpty());
			connection.close();
//			doCountQuery(context.stringValue());
			return context.stringValue();
		} catch (RDFParseException e) {
			logger.error("Could not parse remote file. {}", e);
			throw new RdfException("Error parsing file. ", e);
		} catch (IOException e) {
			logger.error("Error retrieving remote file. {}", e);
			throw new RdfException("Error retrieving remote file.", e);
		} catch (RepositoryException e) {
			logger.error("Problem with local repoistory. {}", e);
			throw new RdfException("Repository problem. ", e);
		}
	}

	private Resource getNewContext() {
		long currentTimeMillis = System.currentTimeMillis();
		URI context = new URIImpl(BASEURI + currentTimeMillis);
		return context;
	}

	public Set<String> getVocabularies(String context) throws RdfException {
		String query = "SELECT DISTINCT ?p FROM <" + context + "> WHERE {?s ?p ?o}";
		try {
			RepositoryConnection connection = getConnection();
			TupleQuery tupleQuery = connection.prepareTupleQuery(QueryLanguage.SPARQL, query);
			TupleQueryResult result = tupleQuery.evaluate();
			Set<String> vocabularies = new HashSet<String>();
			while (result.hasNext()) {
				BindingSet bindingSet = result.next();
				URI value = (URI) bindingSet.getValue("p");
				vocabularies.add(value.getNamespace());
			}
			return vocabularies;
		} catch (RepositoryException e) {
			String message = "Unable to get namespaces from the repository.";
			logger.warn(message);
			throw new RdfException(message, e);
		} catch (MalformedQueryException e) {
			logger.error("Malformed query {}", query);
			throw new RdfException("Malformed query ", e);
		} catch (QueryEvaluationException e) {
			logger.warn("Problem evaluating query {}", query);
			throw new RdfException("Query evalution error", e);
		}
	}

	public TupleQueryResult query(String queryString) throws RdfException {
		try {
			RepositoryConnection connection = getConnection();
			TupleQuery tupleQuery = connection.prepareTupleQuery(QueryLanguage.SPARQL, queryString);
			TupleQueryResult result = tupleQuery.evaluate();
			return result;
		} catch (QueryEvaluationException e) {
			logger.warn("Problem evaluating query {}", queryString);
			throw new RdfException("Query evalution error", e);
		} catch (RepositoryException e) {
			logger.error("Problem with local repoistory. {}", e);
			throw new RdfException("Repository problem.", e);
		} catch (MalformedQueryException e) {
			logger.error("Malformed query {}", queryString);
			throw new RdfException("Malformed query ", e);
		}
	}

	public String getLiteralValueAsString(String query, String parameterName) throws RdfException {
		Value value = null;
		try {
			logger.debug("Query: {}", query);
			TupleQueryResult queryResult = query(query);
			BindingSet bindingSet = queryResult.singleResult();
			logger.debug("Result bindings: {}", bindingSet.toString());
			value = bindingSet.getValue(parameterName);
			if (value == null) {
				logger.warn("{} not found in data.", parameterName);
				throw new RdfException(parameterName + " not found");
			}
			return value.stringValue();
		} catch (QueryEvaluationException e) {
			logger.error("Problem processing query results. {}", e);
			throw new RdfException("Problem processing results.", e);
		}
	}

	private void doCountQuery(String dataContext) {		
		String queryString =
				"SELECT (COUNT (DISTINCT ?s ) AS ?no) " +
				"FROM <" + dataContext + "> " +
				"WHERE { ?s ?p ?o }";
		try {
			RepositoryConnection connection = getConnection();
			TupleQuery tupleQuery = connection.prepareTupleQuery(QueryLanguage.SPARQL, queryString);
			TupleQueryResult result = tupleQuery.evaluate();
			while (result.hasNext()) {
				BindingSet bindingSet = result.next();
				String count = bindingSet.getValue("no").stringValue();
				logger.info("Count: {}", count);
				return;
			}
		} catch (RdfException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (RepositoryException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (MalformedQueryException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (QueryEvaluationException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	public void addTripleWithLiteral(String subject, String predicate, String object, String context) 
			throws RdfException {
		try {
			RepositoryConnection connection = getConnection();			
			ValueFactory myFactory = connection.getValueFactory();
			Literal obValue = myFactory.createLiteral(object);
			connection.add(new URIImpl(subject), new URIImpl(predicate), obValue, new URIImpl(context));
		} catch (RepositoryException e) {
			logger.warn("Failed to add quad: {}, {}, {}, {}", subject, predicate, object, context);
			throw new RdfException("Failed to load quad. ", e);
		}
	}

	public void addTripleWithDateTime(String subject, String predicate, XMLGregorianCalendar datetime, 
			String context) 
			throws RdfException {
		try {
			RepositoryConnection connection = getConnection();			
			ValueFactory myFactory = connection.getValueFactory();
			Literal obValue = myFactory.createLiteral(datetime);
			connection.add(new URIImpl(subject), new URIImpl(predicate), obValue, new URIImpl(context));
		} catch (RepositoryException e) {
			logger.warn("Failed to add quad: {}, {}, {}, {}", subject, predicate, datetime, context);
			throw new RdfException("Failed to load quad. ", e);
		}
	}

	public void addTripleWithURI(String subject, String predicate, String object, String context) 
			throws RdfException {
		try {
			RepositoryConnection connection = getConnection();			
			connection.add(new URIImpl(subject), new URIImpl(predicate), new URIImpl(object), 
					new URIImpl(context));
		} catch (RepositoryException e) {
			logger.warn("Failed to add quad: {}, {}, {}, {}", subject, predicate, object, context);
			throw new RdfException("Failed to load quad. ", e);
		}
	}

	public void writeToFile(String context, String fileName) throws RdfException {
		RepositoryConnection connection = getConnection();
		RDFWriter rdfWriter;
		try {
			rdfWriter = Rio.createWriter(RDFFormat.TURTLE, 
			        new FileOutputStream(fileName));
			connection.export(rdfWriter, new URIImpl(context));
		} catch (UnsupportedRDFormatException e) {
			String message = "Unsupported file format.";
			logger.warn(message);
			throw new RdfException(message, e);
		} catch (FileNotFoundException e) {
			String message = "Unable to write to file: " + fileName;
			logger.warn(message);
			throw new RdfException(message, e);
		} catch (RepositoryException e) {
			String message = "Unable to access the repository.";
			logger.warn(message);
			throw new RdfException(message, e);
		} catch (RDFHandlerException e) {
			String message = "Problem writing triples to file.";
			logger.warn(message);
			throw new RdfException(message, e);
		}
	}

	public void removeContext(String context) throws RdfException {
		RepositoryConnection connection = getConnection();
		try {
			logger.debug("Clearing context {}", context);
			connection.clear(new URIImpl(context));
			logger.debug("Size of repository: {}", connection.size());
		} catch (RepositoryException e) {
			String message = "Unable to remove context from the repository.";
			logger.warn(message);
			throw new RdfException(message, e);
		}
	}

	public void close() throws RdfException {
		try {
			RepositoryConnection connection = getConnection();
			logger.info("Closing repository connection");
			connection.close();
		} catch (RepositoryException e) {
			String message = "Unable to close the repository.";
			logger.warn(message);
			throw new RdfException(message, e);
		}
	}
	
}
