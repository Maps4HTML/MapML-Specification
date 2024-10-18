# MapML

[Map Markup Language](https://maps4html.org/MapML-Specification/spec/) is a proposed HTML vocabulary for maps. 
Although document validity is not a concept that can be strictly enforced on the internet, 
the documents in this directory are an attempt to provide guidance to map authors on what 
constitutes markup that is understood as being within scope of the MapML specification.

In principle, a MapML document should be parseable the HTML parser, because
many of the elements are extended from the HTML namespace and are intended to have 
identical processing semantics to their counterpart in HTML apart from extensions specified in MapML.

In practice, no such MapML/HTML parser exists at the time of writing, and it should be good enough to encode
a MapML document in HTML5 XML syntax in the XHTML namespace, so that Web browsers' 
XML parsers can be used.  When such a parser is used, it should be possible to use 
the schema / schematron documents in this directory to validate certain
rules of MapML and XHTML documents.  The schemas / schematron files in this directory are intended to 
evolve as the concept of MapML evolves. 

## Instructions

mapml.rnc (a [RelaxNG](http://www.relaxng.org/compact-tutorial-20030326.html) compact syntax schema) 
and mapml.sch (post-schema validation MapML schematron rules) are intended to be 
applied in that order, to validate a "stand-alone" MapML document.  Such a document 
would be loaded into an HTML document by the <map-layer> custom element, via a URL 
reference in the src attribute:  `<map-layer src="URL to MapML document goes here"></map-layer>`.

Another scenario that is conceptually supported is to have an (X)HTML document that
contains a <mapml-viewer> element that contains one or more <map-layer> elements that
in turn contain 'inline' MapML content, i.e. MapML vocabulary elements contained
within the <map-layer></map-layer> begin and end tags.

I couldn't get a version of an rnc schema for xhtml to work, so I have to be satisfied
with validating a document that contains only a `<mapml-viewer>` element, with the
correct namespace xmlns value for XHTML. See mapml-viewer.xhtml as an example.

To validate this latter type of document, I 'forked' the mapml.rnc document into
mapml-viewer.rnc.  You can validate mapml-viewer.xhtml and similar documents by
using the mapml-viewer.rnc schema validation phase, followed by the mapml-viewer.sch
schematron validation.  These scenarios may not be perfectly adapted; please get
in touch if you have a document that doesn't validate, but you think it should, 
or vice versa.

I use the Oxygen XML editor to create a global validation scenario for MapML documents,
but you can use any engines which support those technologies, I believe.

PR

