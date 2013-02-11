package org.openphacts.data.rdf;
import java.io.File;
import java.io.IOException;
import java.net.URL;

import org.openrdf.model.Resource;
import org.openrdf.model.URI;
import org.openrdf.model.impl.URIImpl;
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
import org.openrdf.rio.RDFParseException;
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
			logger.error("Error initializing Repository. ", ex);
		}
	}
	
	private RepositoryConnection getConnection() throws RdfException{
		try {
			RepositoryConnection connection =  repository.getConnection();
			return connection;
		} catch (RepositoryException ex) {
			logger.error("Unable to get connection. ", ex);
			throw new RdfException("Unable to establish a connection.");
		}
	}
	
	public String loadRdf(URL file, String baseURI, RDFFormat format) throws RdfException {
		try {
			RepositoryConnection connection = getConnection();
			Resource context = getNewContext();
			connection.add(file, baseURI, format, context);
			logger.debug("empty after data load: " + connection.isEmpty());
			connection.close();
			return context.stringValue();
		} catch (RDFParseException e) {
			logger.error("Could not parse remote file. " + e);
			throw new RdfException("Error parsing file.", e);
		} catch (IOException e) {
			logger.error("Error retrieving remote file. " + e);
			throw new RdfException("Error retrieving remote file.", e);
		} catch (RepositoryException e) {
			logger.error("Problem with local repoistory. " + e);
			throw new RdfException("Repository problem.", e);
		}
	}

	private Resource getNewContext() {
		long currentTimeMillis = System.currentTimeMillis();
		URI context = new URIImpl(BASEURI + currentTimeMillis);
		return context;
	}

	public TupleQueryResult query(String queryString, String dataContext) throws RdfException {
		try {
			RepositoryConnection connection = getConnection();
			logger.debug("Empty before query: " + connection.isEmpty());
			TupleQuery tupleQuery = connection.prepareTupleQuery(QueryLanguage.SPARQL, queryString);
			TupleQueryResult result = tupleQuery.evaluate();
			return result;
		} catch (QueryEvaluationException e) {
			logger.warn("Problem evaluating query " + queryString);
			throw new RdfException("Query evalution error", e);
		} catch (RepositoryException e) {
			logger.error("Problem with local repoistory. " + e);
			throw new RdfException("Repository problem.", e);
		} catch (MalformedQueryException e) {
			logger.error("Malformed query " + queryString);
			throw new RdfException("Malformed query", e);
		}
	}
	
}
