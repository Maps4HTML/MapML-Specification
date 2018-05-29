# MapML

[Map Markup Language](http://maps4html.github.io/MapML/spec/) is  'MicroXML' vocabulary for maps. 
Although document validity is not a concept that can be strictly enforced on the internet, 
the documents in this directory are an attempt to provide guidance to map authors on what 
constitutes markup that is understood as being within scope of the MapML specification.

In principle, a MapML document should be parseable with an HTML-like parser, because
many of the elements are copied from the HTML vocabulary and are intended to have 
identical processing semantics to their counterpart in HTML.

In practice, no such MapML parser exists at the time of writing, and it should be good enough to encode
a MapML document in [MicroXML](https://dvcs.w3.org/hg/microxml/raw-file/tip/spec/microxml.html) syntax so that an XML parser can be used.  When such a parser is used,
it should be possible to use the schema / schematron documents in this directory to validate certain
rules of MapML documents.  The schemas / schematron files in this directory are intended to 
evolve as the concept of MapML evolves, and perhaps at some point when enough people
get involved we will be able to 'fork' the nu validator / parser for HTML to provide a similarly
robust parsing and validation service online. 

## Instructions

The files microxml.sch (a single [schematron](http://schematron.com/) validation rule for MicroXML syntax),
mapml.rnc (a [RelaxNG](http://www.relaxng.org/compact-tutorial-20030326.html) compact syntax schema) and mapml.sch (post-schema validation MapML
schematron rules) are intended to be applied in that order.

I use the Oxygen XML editor to create a global validation scenario for MapML documents,
but you can use any engines which support those technologies, I believe.

PR

