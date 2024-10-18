<?xml version="1.0" encoding="UTF-8"?>
<sch:schema  xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process" xmlns:xs="http://www.w3.org/2001/XMLSchema-datatypes" xmlns="http://www.w3.org/1999/xhtml">
    <sch:ns uri="http://www.w3.org/1999/xhtml"  prefix="h"/>
    <sch:pattern>
        <sch:rule context="h:map-layer">
            <sch:assert test="local-name(parent::*) eq 'mapml-viewer'">The map-layer element must be a child of the mapml-viewer element</sch:assert>
            <sch:assert test="((exists(@src) and not(exists(./*))) or (not(exists(@src)) and exists(./*)))">The &lt;map-layer&gt; element must have either a src attribute or inline content</sch:assert>
        </sch:rule>
        <sch:rule context="h:map-layer[child::h:map-title]/@label">
            <sch:assert test="false()">In the case that a label attribute exists and a map-title element is present, the map-title will be preferred.</sch:assert>
        </sch:rule>
        <sch:rule context="h:layer">
            <sch:assert test="false()">The map-layer element MUST have a trailing hyphen: map-layer</sch:assert>
        </sch:rule>
    </sch:pattern>
    <sch:pattern>
        <sch:rule context="h:mapml-viewer">
<!--            <sch:assert test="ancestor::h:body">The mapml-viewer element must be a descendant of the html &lt;body&gt; element</sch:assert>
            <sch:assert test="ancestor::h:html">The mapml-viewer element must be a descendant of the &lt;html&gt; element</sch:assert>-->
            <sch:assert test="every $exists in (exists(@projection),exists(@lat),exists(@lon),exists(@zoom)) satisfies $exists">The mapml-viewer element must have the projection, lat, lon and zoom attributes</sch:assert>
            <sch:assert test="some $prj in ('OSMTILE','CBMTILE','WGS84','APSTILE') satisfies $prj eq @projection">The projection attribute must have a value that is one of: 'OSMTILE','CBMTILE','WGS84' or 'APSTILE'</sch:assert>
            <sch:assert test="matches(attribute(lat), '^-?\d+\.?\d*$')">The value of lat attribute must be a number</sch:assert>
            <sch:assert test="matches(attribute(lon), '^-?\d+\.?\d*$')">The value of lon attribute must be a number</sch:assert>
            <sch:assert test="matches(attribute(zoom), '^([0-9]|1[0-9]|2[0-6])$')">The value of zoom attribute must be an integer between 0 and 26</sch:assert>
            <sch:assert test="attribute(lon) castable as xs:decimal and xs:decimal(attribute(lon)) ge -180.0 and xs:decimal(attribute(lon)) le 180.0">lon attribute must be greater than or equal to -180 and less than or equal to 180</sch:assert>
            <sch:assert test="attribute(lat) castable as xs:decimal and xs:decimal(attribute(lat)) ge -90.0 and xs:decimal(attribute(lat)) le 90.0">lat attribute must be greater than or equal to -90 and less than or equal to 90</sch:assert>
            <sch:assert test="every $control in tokenize(@controlslist,' ') satisfies  not(empty(('nolayer','nozoom','noreload','nofullscreen','noscale','geolocation')[. eq $control]))">controlslist value must be one or more of ('nolayer','nozoom','noreload','nofullscreen','noscale','geolocation')</sch:assert>
        </sch:rule>
    </sch:pattern>
</sch:schema>