package org.openphacts.data.rdf;

import java.net.MalformedURLException;
import java.net.URL;

public class ChebiPipeline {

	private static final String CHEBI_BASE = "http://purl.obolibrary.org/obo/";

	public static void usage() {
		System.out.println("Please specify the location of the ChEBI OWL file.");
	}
	
	/**
	 * @param args
	 * @throws RdfException 
	 * @throws MalformedURLException 
	 */
	public static void main(String[] args) throws MalformedURLException, RdfException {
		if (args.length != 1) {
			usage();
			System.exit(1);
		}
		ChebiPipeline chebiPipeline = new ChebiPipeline();
		chebiPipeline.run(args[0]);
	}

	private RdfRepository repository;

	public ChebiPipeline() {
		repository = new RdfRepository();
	}
	
	public void run(String urlString) throws MalformedURLException, RdfException {
		URL url = new URL(urlString);
		String context = repository.loadRdf(url, CHEBI_BASE);
		System.out.println("Data successfully loaded into " + context);
	}
	
}
