package org.openphacts.data.rdf;

public class RdfException extends Exception {

	public RdfException(String message) {
		super(message);
	}

	public RdfException(String message, Throwable e) {
		super(message, e);
	}

}
