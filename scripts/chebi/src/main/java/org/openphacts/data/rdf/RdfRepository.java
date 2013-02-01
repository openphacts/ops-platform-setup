package org.openphacts.data.rdf;
import java.io.IOException;
import java.net.URL;

import org.openrdf.model.Resource;
import org.openrdf.model.URI;
import org.openrdf.model.impl.URIImpl;
import org.openrdf.repository.Repository;
import org.openrdf.repository.RepositoryConnection;
import org.openrdf.repository.RepositoryException;
import org.openrdf.repository.sail.SailRepository;
import org.openrdf.sail.memory.MemoryStore;
import org.openrdf.rio.RDFFormat;
import org.openrdf.rio.RDFParseException;
import org.slf4j.Logger;

public class RdfRepository {

	private Logger logger;
	
	private Repository repository  = new SailRepository(new MemoryStore());;

	private static final String BASEURI = "http://www.openphacts.org/";
	
	private RepositoryConnection getConnection() throws RdfException{
		try {
			repository.initialize();
		} catch (RepositoryException ex) {
			logger.error("Error initializing Repository. ", ex);
		}
		try {
			RepositoryConnection connection;
			connection =  repository.getConnection();
			return connection;
		} catch (RepositoryException ex) {
			logger.error("Unable to get connection. ", ex);
			throw new RdfException("Unable to establish a connection.");
		}
	}
	
	public String loadRdf(URL file, String baseURI) throws RdfException {
		try {
			RepositoryConnection connection = getConnection();
			Resource context = getNewContext();
			connection.add(file, baseURI, null, context);
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
	
}
