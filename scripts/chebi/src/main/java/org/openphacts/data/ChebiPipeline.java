package org.openphacts.data;

import java.net.MalformedURLException;
import java.net.URL;

import org.openphacts.data.rdf.RdfException;
import org.openphacts.data.rdf.RdfRepository;
import org.openrdf.rio.RDFFormat;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class ChebiPipeline {

	private static final String CHEBI_BASE = "http://purl.obolibrary.org/obo/";
	
	private final Logger logger = LoggerFactory.getLogger(ChebiPipeline.class);
	
	public static void usage() {
		System.out.println("Please specify three input parameters: ");
		System.out.println("\tthe URI of the ChEBI OWL file;");
		System.out.println("\ta base URI for the generated VoID files;");
		System.out.println("\ta URI for the person running the script.");
	}
	
	/**
	 * @param args
	 * @throws RdfException 
	 * @throws MalformedURLException 
	 * @throws VoIDException 
	 */
	public static void main(String[] args) throws MalformedURLException, RdfException, VoIDException {
		if (args.length != 3) {
			usage();
			System.exit(1);
		}
		ChebiPipeline chebiPipeline = new ChebiPipeline();
		chebiPipeline.run(args[0], args[1], args[2]);
	}

	private RdfRepository repository;

	public ChebiPipeline() {
		repository = new RdfRepository();
	}
	
	public void run(String downloadUrlString, String baseURI, String creatorURL) 
			throws MalformedURLException, RdfException, VoIDException {
		try {
			URL url = new URL(downloadUrlString);
			logger.info("Downloading file from {}", downloadUrlString);
			String context = repository.loadRdf(url, CHEBI_BASE, RDFFormat.RDFXML);
			logger.info("Data successfully loaded into {}", context);
			logger.info("Generating VoID descriptor for ChEBI.");
			VoidGenerator generator = new VoidGenerator(repository);
			String fileName = generator.generateVoid(context, downloadUrlString, baseURI, creatorURL);
			logger.info("VoID descriptor successfully generated {}", fileName);
			repository.close();
			System.out.println("ChEBI VoID file available from " + fileName);
		} catch (MalformedURLException e) {
			repository.close();
			throw e;
		} catch (RdfException e) {
			repository.close();
			throw e;
		} catch (VoIDException e) {
			repository.close();
			throw e;
		}
	}
	
}
