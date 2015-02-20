import os
import re
import sys
from ftplib import FTP
import gzip
from rdflib import RDF, ConjunctiveGraph, Namespace, URIRef, Literal, BNode

# Default paths
INPUT_FOLDER = 'input/'
OUTPUT_FOLDER = 'output/'

# Debugging
verbose_log = True
stop_after_one_file = False

# Write this many entries to one file to limit the size of an RDF graph.
BLOCK_SIZE = 65536

# Evidence translation
class EcoEvidence(object):
        # See: http://wiki.geneontology.org/index.php/Evidence_Code_Ontology_(ECO)
        rawdata = [
          ('IEA', 'GO_REF:0000040', 'ECO:0000323'),
          ('IEA', 'GO_REF:0000038', 'ECO:0000323'),
          ('IEA', 'GO_REF:0000039', 'ECO:0000322'),
          ('IEA', 'GO_REF:0000037', 'ECO:0000322'),
          ('IEA', 'GO_REF:0000049', 'ECO:0000265'),
          ('IEA', 'GO_REF:0000002', 'ECO:0000256'),
          ('IEA', 'GO_REF:0000020', 'ECO:0000265'),
          ('IEA', 'GO_REF:0000004', 'ECO:0000203'),
          ('IEA', 'GO_REF:0000023', 'ECO:0000203'),
          ('IEA', 'GO_REF:0000019', 'ECO:0000265'),
          ('IEA', 'GO_REF:0000035', 'ECO:0000265'),
          ('IEA', 'GO_REF:0000003', 'ECO:0000203'),
          ('IEA', None, 'ECO:0000203'),
          ('ND', None, 'ECO:0000307'),
          ('EXP', None, 'ECO:0000269'),
          ('IDA', None, 'ECO:0000314'),
          ('IMP', None, 'ECO:0000315'),
          ('IGI', None, 'ECO:0000316'),
          ('IEP', None, 'ECO:0000270'),
          ('IPI', None, 'ECO:0000021'),
          ('TAS', None, 'ECO:0000304'),
          ('NAS', None, 'ECO:0000303'),
          ('IC', None, 'ECO:0000305'),
          ('ISS', 'GO_REF:0000027', 'ECO:0000031'),
          ('ISS', 'GO_REF:0000011', 'ECO:0000255'),
          ('ISS', 'GO_REF:0000012', 'ECO:0000031'),
          ('ISS', 'GO_REF:0000018', 'ECO:0000031'),
          ('ISS', None, 'ECO:0000250'),
          ('ISO', None, 'ECO:0000266'),
          ('ISA', None, 'ECO:0000247'),
          ('ISM', None, 'ECO:0000255'),
          ('IGC', 'GO_REF:0000025', 'ECO:0000084'),
          ('IGC', None, 'ECO:0000317'),
          ('IBA', None, 'ECO:0000318'),
          ('IBD', None, 'ECO:0000319'),
          ('IKR', None, 'ECO:0000320'),
          ('IRD', None, 'ECO:0000321'),
          ('RCA', None, 'ECO:0000245'),
          ('IMR', None, 'ECO:0000320'),
                        ]

        def __init__(self):
                self.data = {}
                self.gorefs = set()
                for code, goref, eco in self.rawdata:
                        if self.data.has_key(code):
                                cur = self.data[code]
                                cur[goref] = eco
                        else:
                                self.data[code] = {goref: eco}
                        if goref is not None:
                                self.gorefs.add(goref)

        def map(self, code, goref):
                if not self.data.has_key(code):
                        raise KeyError("Unknown GO Evidence code: %s" % code)
                x = self.data[code]
                if x.has_key(goref):
                        return x[goref]
                if goref in self.gorefs:
                        if code in ('IDA', 'IMP', 'IGI', 'IPI', 'IGC') and goref == 'GO_REF:0000012':
                                print >> sys.stderr, "Evidence map: %s+GO_REF:0000012 is an impossible combination. Special fix invoked" % code
                                # They are incompatible. Assume that code is wrong, it should have been ISS.
                                return 'ECO:0000031'
                        if code in ('IMP', ) and goref == 'GO_REF:0000020':
                                print >> sys.stderr, "Evidence map: %s+GO_REF:0000020 is difficult choice. Special fix invoked" % code
                                # Keep the most detailed one
                                return 'ECO:0000265'
                        if code in ('IDA', 'IEP') and goref == 'GO_REF:0000002':
                                print >> sys.stderr, "Evidence map: %s+GO_REF:0000002 is difficult choice. Special fix invoked" % code
                                # Keep the most detailed one
                                return 'ECO:0000256'
                        if code == 'IC' and goref == 'GO_REF:0000012':
                                print >> sys.stderr, "Evidence map: IC+GO_REF:0000012 is a difficult choice. Special fix invoked"
                                # Inferred by Curator is the strongest of the two evidences. Keep it.
                                return 'ECO:0000305'
                        if code == 'IC' and goref == 'GO_REF:0000011':
                                print >> sys.stderr, "Evidence map: IC+GO_REF:0000011 is a difficult choice. Special fix invoked"
                                # Inferred by Curator is the strongest of the two evidences. Keep it.
                                return 'ECO:0000305'
                        raise KeyError("GO_REF exists but under another Evidence code: %s (%s)" % (goref, code))
                return x[None]

        def urlmap(self, code, goref):
                return "http://purl.obolibrary.org/obo/eco.owl#" + self.map(code, goref)

ecoEvidence = EcoEvidence()

def testmap():
    assert ecoEvidence.map('IMR','bla') == 'ECO:0000320'
    assert ecoEvidence.map('IGC','GO_REF:0000025') == 'ECO:0000084'

testmap()

# get all input files
class Retriever(object):
	def __init__(self):
		self.currentfile = None

	def getinput(self):
		ftp = FTP('ftp.geneontology.org')
		ftp.login()
		ftp.cwd('pub/go/gene-associations/')
		
		lines = ftp.nlst()
		for line in lines:
			if line[-3:] == '.gz':
				file = INPUT_FOLDER+line
				if os.path.exists(file):
					print 'Skipping '+file
				else:
					print 'Downloading '+line
					self.currentfile = open(file, 'w')
					ftp.retrbinary('RETR '+line, self.downloadblock)
					self.currentfile.flush()
					self.currentfile.close()
			
		ftp.quit()
		ftp.close()

	def downloadblock(self, block):
		self.currentfile.write(block)

class AnnotationEntry(object):
	def __init__(self,line):
		columns = line.split('\t')
		self.DB = columns[0]
		self.DB_objID = columns[1]
		self.DB_objSymbol = columns[2]
		self.Qualifier = columns[3]
		self.GO_ID = columns[4]
		self.DB_Ref = columns[5]
		self.Evidence = columns[6]
		self.With = columns[7]
		self.Aspect = columns[8]
		self.DB_objName = columns[9]
		self.DB_objSyn = columns[10]
		self.DB_objType = columns[11]
		self.Taxon = columns[12]
		self.Date = columns[13]
		self.AssignedBy = columns[14]
		self.AnnotationExt = columns[15]
		self.GeneProductFormID = columns[16]

# parse file
class Parser(object):
	def __init__(self, outputter):
		self.outputter = outputter

	def parsedir(self, dirname):
		fnlist = os.listdir(dirname)
		fnlist.sort()
		for filename in fnlist:
			self.parsefile(os.path.join(dirname, filename))

	def parsefile(self, filename):
		if verbose_log:
			sys.stderr.write('Parsing %s\n' % filename)
			
		if filename.endswith('.gz'):
                    f = gzip.open(filename, 'rb')
		else:
                    f = open(filename, 'r')

		self.outputter.outputopen(filename)
			
		self.readfile(f)
		self.outputter.outputclose()
			
		f.close()
		if verbose_log:
			sys.stderr.write('Finished %s\n' % filename)
			
		if stop_after_one_file:
			print 'stopping after the first file!'
			sys.exit(1)

	def readfile(self,file):
		for line in file:
			if len(line) > 0 and line[0] is not '!':
				entry = AnnotationEntry(line.strip('\n'))
				self.outputter.output(entry)

# output file
class Outputter(object):
	RDF_NS = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#'
	RDFS_NS = 'http://www.w3.org/2000/01/rdf-schema#'
	GOA_NS = 'http://www.semantic-systems-biology.org/ontology/rdf/GOA#'
	UNIPROT_NS = 'http://purl.uniprot.org/uniprot/'
	OBO_NS = 'http://www.semantic-systems-biology.org/ontology/rdf/OBO#'
	NCBI_NS = 'http://www.semantic-systems-biology.org/ontology/rdf/NCBI#'
        # GO_NS = 'http://www.geneontology.org/go#' # RWWH: replaced in September 2013.
        GO_NS = 'http://purl.org/obo/owl/GO#'
        PUBMED_NS = 'http://www.ncbi.nlm.nih.gov/pubmed/'

	def __init__(self):
		self.rdf = Namespace(self.RDF_NS)
		self.rdfs = Namespace(self.RDFS_NS)
		self.goa = Namespace(self.GOA_NS)
		self.uniprot = Namespace(self.UNIPROT_NS)
		self.obo = Namespace(self.OBO_NS)
		self.ncbi = Namespace(self.NCBI_NS)
		self.pubmed = Namespace(self.PUBMED_NS)

	def newgraph(self):
		graph = ConjunctiveGraph()
		graph.bind('rdf', self.rdf)
		graph.bind('rdfs', self.rdfs)
		graph.bind('goa', self.goa)
		graph.bind('uniprot', self.uniprot)
		graph.bind('obo', self.obo)
		graph.bind('ncbi', self.ncbi)
		graph.bind('pubmed', self.pubmed)
		self.graph = graph
		self.nentries = 0

	def outputopen(self, filename):
		self.filename = os.path.join(OUTPUT_FOLDER, os.path.split(filename)[1])
		if self.filename.endswith('.gz'):
			self.filename = self.filename[:-3]

		self.uniqueAssocId = 0
		self.newgraph()
		self.nblock = 0

	def output(self, entry):
		self.nentries += 1
		#
		# the protein
		#
		subject = URIRef(self.UNIPROT_NS+entry.DB_objID)
		self.graph.add((subject, self.rdfs['label'], Literal(entry.DB_objSymbol)))
		
		self.graph.add((subject, self.goa['annot_src'], Literal(entry.AssignedBy)))
		
		# need to replace taxon: with NCBI_ ??
		t = re.sub('taxon:', 'NCBI_', entry.Taxon)
		self.graph.add((subject, URIRef(self.goa['taxon']), Literal(t)))
		self.graph.add((subject, URIRef(self.obo['has_source']), URIRef(self.NCBI_NS+t)))
		
		self.graph.add((subject, URIRef(self.goa['type']), Literal(entry.DB_objType)))
		
		self.graph.add((subject, URIRef(self.goa['description']), Literal(entry.DB_objName)))

		self.graph.add((subject, URIRef(self.goa['obj_src']), Literal(entry.DB)))
		
		#
		# assoc
		#
		self.uniqueAssocId += 1
		assocSubject = URIRef(self.GOA_NS+'triple_'+re.sub('\.', '_',self.filename[:-3])+'_'+str(self.uniqueAssocId))
		self.graph.add((assocSubject, URIRef(self.goa['date']), Literal(entry.Date)))
                if entry.DB_Ref.startswith('PMID'):
                        link = URIRef(self.PUBMED_NS+entry.DB_Ref[5:])
                else:
                        link = Literal(entry.DB_Ref)
		self.graph.add((assocSubject, URIRef(self.goa['refer']), link))
		self.graph.add((assocSubject, URIRef(self.goa['sup_ref']), Literal(entry.With)))
                if entry.Evidence != 'NR': # Not Recorded
		        self.graph.add((assocSubject, URIRef(self.obo['has_evidence']), URIRef(ecoEvidence.urlmap(entry.Evidence,entry.DB_Ref))))

		#
		# triple
		#
                goid = entry.GO_ID.replace('GO:', 'GO_')
                self.graph.add((subject, URIRef(self.OBO_NS+entry.Aspect), URIRef(self.GO_NS+goid)))
                self.graph.add((subject, URIRef(self.goa['association']), assocSubject))


		if self.nentries >= BLOCK_SIZE :
			self.writeblock()
	
	def outputclose(self):
		if self.nentries > 0:
			self.writeblock()

	def writeblock(self):
		self.nblock += 1
		self.file = gzip.open(self.filename+'%05d.rdf.gz' % self.nblock, 'w')
		self.file.write(self.graph.serialize(format='pretty-xml'))
		self.file.close()
		self.newgraph()

if __name__ == "__main__":
#	r = Retriever()
#	r.getinput()
	
	o = Outputter()
	p = Parser(o)
	if len(sys.argv)!=2:
		print "Please specify a file or directory as argument"
		sys.exit(1)
	if os.path.isdir(sys.argv[1]):
		p.parsedir(sys.argv[1])
	elif os.path.exists(sys.argv[1]):
		if False: # Profile the run?
			def x():
				p.parsefile(sys.argv[1])
			import profile
			profile.run('x()')
		else:
			p.parsefile(sys.argv[1])
	else:
		print "Not found"
		sys.exit(1)
