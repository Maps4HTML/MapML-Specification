# MapML

[Map Markup Language](https://maps4html.org/MapML/spec/) is a proposed HTML vocabulary for maps. 
Although document validity is not a concept that can be strictly enforced on the internet, 
the documents in this directory are an attempt to provide guidance to map authors on what 
constitutes markup that is understood as being within scope of the MapML specification.

In principle, a MapML document should be parseable the HTML parser, because
many of the elements are extended from the HTML namespace and are intended to have 
identical processing semantics to their counterpart in HTML apart from extensions specified in MapML.

In practice, no such MapML/HTML parser exists at the time of writing, and it should be good enough to encode
a MapML document in HTML5 XML syntax so that Web browsers' XML parsers can be used.  When such a parser is used,
it should be possible to use the schema / schematron documents in this directory to validate certain
rules of MapML documents.  The schemas / schematron files in this directory are intended to 
evolve as the concept of MapML evolves. 

## Instructions

mapml.rnc (a [RelaxNG](http://www.relaxng.org/compact-tutorial-20030326.html) compact syntax schema) and mapml.sch (post-schema validation MapML
schematron rules) are intended to be applied in that order.

I use the Oxygen XML editor to create a global validation scenario for MapML documents,
but you can use any engines which support those technologies, I believe.

PR

