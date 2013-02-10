package org.openphacts.data;

import java.net.MalformedURLException;
import java.net.URL;

import org.openphacts.data.rdf.RdfException;
import org.openphacts.data.rdf.RdfRepository;
import org.openrdf.rio.RDFFormat;

public class ChebiPipeline {

	private static final String CHEBI_BASE = "http://purl.obolibrary.org/obo/";

	public static void usage() {
		System.out.println("Please specify the location of the ChEBI OWL file.");
	}
	
	/**
	 * @param args
	 * @throws RdfException 
	 * @throws MalformedURLException 
	 * @throws VoIDException 
	 */
	public static void main(String[] args) throws MalformedURLException, RdfException, VoIDException {
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
	
	public void run(String urlString) throws MalformedURLException, RdfException, VoIDException {
		URL url = new URL(urlString);
		String context = repository.loadRdf(url, CHEBI_BASE, RDFFormat.RDFXML);
		System.out.println("Data successfully loaded into " + context);
		VoidGenerator generator = new VoidGenerator(repository);
		generator.generateVoid(context);
	}
	
}
