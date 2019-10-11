<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process" xmlns:xs="http://www.w3.org/2001/XMLSchema-datatypes" >
    <sch:pattern >
        <sch:rule context="input[@type='location'][@units eq 'tilematrix'][@axis eq 'row' or @axis eq 'column']">
            <sch:assert test="./@rel eq 'map' or not(./@rel)">For inputs[@type=location], @rel must equal 'map' or not exist</sch:assert>
        </sch:rule>
        <sch:rule context="input[@type='location'][@units eq 'map']">
            <sch:assert test="./@axis eq 'j' or ./@axis eq 'i'">For inputs[@type=location][units=map] @axis must exist and be equal to either i or j</sch:assert>
        </sch:rule>
        <sch:rule context="input[@type='location'][@axis eq 'easting']">
            <sch:assert test="exists(preceding-sibling::input[@axis eq 'northing']) or exists(following-sibling::input[@axis eq 'northing'])">Easting axis reference must have paired northing axis reference</sch:assert>
        </sch:rule>
        <sch:rule context="input[@type='location'][@axis eq 'northing']">
            <sch:assert test="exists(preceding-sibling::input[@axis eq 'easting']) or exists(following-sibling::input[@axis eq 'easting'])">Northing axis reference must have paired easting axis reference</sch:assert>
        </sch:rule>
        <sch:rule context="input[@type='hidden'][@shard]">
            <sch:assert test="exists(./@list)">A shard-type input must have a @list attribute</sch:assert>
            <sch:let name="listid" value="./@list"></sch:let>
            <sch:assert test="exists(//datalist[@id eq $listid])">A datalist must be associated to a shard-type input</sch:assert>
            <sch:report test="exists(./@value)">A shard-type input must not have a @value</sch:report>
        </sch:rule>
        <sch:rule context="input[@shard]">
            <sch:assert test=".[@type eq 'hidden']">A shard-type input must have @type="hidden"</sch:assert>
        </sch:rule>
        <sch:rule context="extent">
            <sch:assert test="input[@type eq 'zoom']">Extent must have a zoom input</sch:assert>
            <sch:assert test="(count((input[@type='location'][@axis eq 'i'] union input[@type='location'][@axis eq 'j'])) mod 2) eq 0">location inputs with axis=i or j must come in pairs</sch:assert>
            <sch:assert test="(count(input[@type='location'][@axis eq 'easting' or @axis eq 'northing']) mod 2) eq 0">location inputs with axis=easting or northing must come in pairs</sch:assert>
            <sch:assert test="(count(input[@type='location'][@axis eq 'latitude' or @axis eq 'longitude']) mod 2) eq 0">location inputs with axis=latitude or longitude must come in pairs</sch:assert>
            <sch:assert test="(count(input[@type='location'][@axis eq 'row' or @axis eq 'column']) mod 2) eq 0">location inputs with axis=row or column must come in pairs</sch:assert>
            <sch:assert test="(count(input[@type='location'][@axis eq 'x' or @axis eq 'y']) mod 2) eq 0">location inputs with axis=x or y must come in pairs</sch:assert>
            <sch:report test="(exists(@method) and not(exists(@action)))">An extent with a method attribute must have an action attribute</sch:report>
        </sch:rule>
    </sch:pattern>
    <sch:pattern>
        <sch:rule context="extent[@action]">
            <sch:assert test="input and (count(link[@rel='query']) eq 1 or not(exists(link[@rel='query'])))"> Extent Content model: If the action attribute exists: A set of multiple input and zero or one link element with its rel attribute in the "query" state.</sch:assert>
        </sch:rule>
        <sch:rule context="extent[not(@action)]">
            <sch:assert test="input and link[@rel=('tile','image','features')] and count(link[@rel eq 'query']) &lt;= 1"> Extent Content model:  If no action attribute exists: A set of multiple input and one or more link elements with their rel attribute in either the "tile", "image" or "features" state, and zero or one link element with its rel attribute in the "query" state.</sch:assert>     
        </sch:rule>
    </sch:pattern>
    <sch:pattern>
        <sch:rule context="head/link">
            <sch:assert test="exists(@href)">Links in head should have a href attribute (head links should not be templated).</sch:assert>
            <sch:report test="exists(@tref)">Links in head should not have a tref attribute (head links should not be templated).</sch:report>
            <sch:let name="recognizedRels" value="'alternate' , 'stylesheet' , 'license' , 'self' , 'style' , 'self style', 'style self', 'legend', 'next', 'zoomin', 'zoomout'"></sch:let>
            <sch:assert test="exists(@rel) and @rel = $recognizedRels">Unrecognized link@rel value (for head link): <sch:value-of select="@rel"/>. Recognized rel values are: <sch:value-of select="$recognizedRels"/></sch:assert>
        </sch:rule>
        <sch:rule context="head/link[@type]">
            <sch:let name="recognizedTypes" value="'text/html','text/css','text/mapml'"></sch:let>
            <sch:report test="@type = $recognizedTypes">Unrecognized link@type value (for head link): <sch:value-of select="@type"/>. Recognized types are: <sch:value-of select="$recognizedTypes"/></sch:report>
        </sch:rule>
        <sch:rule context="head/link[@projection]">
            <sch:report test="@rel ne 'alternate'">projection links must be rel="alternate"</sch:report>
            <sch:report test="exists(@type) and @type ne 'text/mapml'">If alternate projections are provided, the @type must be 'text/mapml', or be unspecified</sch:report>
            <sch:let name="recognizedProjections" value="'OSMTILE' , 'WGS84', 'CBMTILE', 'APSTILE'"></sch:let>
            <sch:report test="upper-case(@projection) = $recognizedProjections">Unrecognized link@projection value:  <sch:value-of select="@projection"/></sch:report>
        </sch:rule>
        <sch:rule context="extent/link">
            <sch:assert test="exists(@tref)">Links in extent should have a tref attribute (extent links must be templated).</sch:assert>
            <sch:report test="exists(@href)">Links in extent should not have a href attribute (extent links must be templated).</sch:report>
            <sch:let name="recognizedRels" value="'image' , 'tile' , 'query' , 'features'"></sch:let>
            <sch:assert test="exists(@rel) and @rel = $recognizedRels">Unrecognized link@rel value (for templated link): <sch:value-of select="@rel"/>. Recognized rel values are: <sch:value-of select="$recognizedRels"/></sch:assert>
        </sch:rule>
        <sch:rule context="extent/link[@type]">
            <sch:let name="recognizedTypes" value="'text/mapml','image/png','image/jpeg'"></sch:let>
            <sch:assert test="@type = $recognizedTypes">Unrecognized link@type value (for templated link): <sch:value-of select="@type"/>. Recognized types are: <sch:value-of select="$recognizedTypes"/></sch:assert>
        </sch:rule>
        <sch:rule context="input[@name = preceding-sibling::input/@name]">
            <sch:assert test="false()">Duplicate input/@name detected</sch:assert>
        </sch:rule>
        <sch:rule context="input[@type eq 'location' or @type eq 'zoom'][@min][@max][xs:decimal(@min) &gt; xs:decimal(@max)]">
            <sch:assert test="false()">@min &gt; @max detected</sch:assert>
        </sch:rule>
        <sch:rule context="link[@tref]">
            <sch:assert test="local-name(parent::node()) eq 'extent'">templated links can only be in the extent element</sch:assert>
        </sch:rule>
        <sch:rule context="link[@projection]">
            <!-- this rule doesn't work. don't know why. <sch:assert test="./@rel eq 'alternate'">For alternate projection links, @rel must equal 'alternate'</sch:assert>-->
            <sch:assert test="local-name(parent::node()) eq 'head'">Alternate projection links can only be in the head element</sch:assert>
        </sch:rule>
        <sch:rule context="link[@href]">
            <sch:assert test="local-name(parent::node()) ne 'extent'">regular links must not be in the extent element</sch:assert>
        </sch:rule>
        <sch:rule context="link[normalize-space(@rel) = 'self style' or normalize-space(@rel) = 'style self']">
            <sch:assert test="count(//link[normalize-space(@rel) = 'self style' or normalize-space(@rel) = 'style self']) eq 1">More than one self style or style self link found</sch:assert>
        </sch:rule>
    </sch:pattern>
    <sch:pattern>
        <sch:rule context="label">
            <sch:assert test="exists(./@for)">A label must have a @for attribute</sch:assert>
            <sch:let name="forid" value="./@for"></sch:let>
            <sch:assert test="exists(//*[@id eq $forid])">A label must be associated to another element by label@for == element@id</sch:assert>
        </sch:rule>
    </sch:pattern>
    <sch:pattern>
        <sch:rule context="select[@id]">
            <sch:let name="forid" value="./@id"></sch:let>
            <sch:assert test="count(//label[@for eq $forid]) eq 1">There must be only one label per labelled (select) element. Duplicated label for id="<sch:value-of select="$forid"/>".</sch:assert>
        </sch:rule>
    </sch:pattern>
    <sch:pattern>
        <sch:rule context="coordinates">
            <sch:let name="cs" value="tokenize(normalize-space(string-join((descendant::text()),' ')),' ')"></sch:let>
            <sch:assert test="(count($cs) mod 2) eq 0">Coordinates must be a sequence of number pairs</sch:assert>
            <sch:assert test="every $c in $cs satisfies ($c castable as xs:double)">Coordinates must all be numeric</sch:assert>
        </sch:rule>
    </sch:pattern>
    <sch:pattern>
        <sch:rule context="polygon/coordinates">
            <sch:let name="cs" value="tokenize(normalize-space(string-join((descendant::text()),' ')),' ')"></sch:let>
            <sch:assert test="(count($cs) idiv 2) ge 3">A polygon's coordinates must be a sequence of three or more pairs of numbers</sch:assert>
            <sch:let name="first" value="subsequence($cs,1,2)"></sch:let>
            <sch:let name="last" value="subsequence($cs,count($cs)-1,2)"></sch:let>
            <sch:assert test="$first[1] eq $last[1] and $first[2] eq $last[2]">A polygon's coordinates must close<sch:value-of select="$first,$last"/></sch:assert>
        </sch:rule>
    </sch:pattern>
    <sch:pattern>
        <sch:rule context="(multilinestring|linestring)/coordinates ">
            <sch:let name="cs" value="tokenize(normalize-space(string-join((descendant::text()),' ')),' ')"></sch:let>
            <sch:assert test="(count($cs) idiv 2) ge 2">A linestring's coordinates must be a sequence of two or more pairs of numbers</sch:assert>
        </sch:rule>
    </sch:pattern>
    <sch:pattern>
        <sch:rule context="multipoint/coordinates ">
            <sch:let name="cs" value="tokenize(normalize-space(string-join((descendant::text()),' ')),' ')"></sch:let>
            <sch:assert test="(count($cs) idiv 2) ge 2">A multipoint's coordinates should be a sequence of two or more pairs of numbers. Should you use a point, instead?</sch:assert>
        </sch:rule>
    </sch:pattern>
    <sch:pattern>
        <sch:rule context="coordinates//span">
            <sch:let name="cs" value="tokenize(normalize-space(string-join((descendant::text()),' ')),' ')"></sch:let>
            <sch:assert test="(count($cs) mod 2) eq 0">A span in coordinates should wrap coordinate pairs.</sch:assert>
            <!-- TODO: a test that the first number in a span is an odd number of positions into the overall set of tokens i.e. 1,3,5, etc -->
        </sch:rule>
    </sch:pattern>
</sch:schema>