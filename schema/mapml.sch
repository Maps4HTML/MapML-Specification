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
        </sch:rule>
        <sch:rule context="link">
            <sch:assert test="(exists(@tref) and not(exists(@href))) or (exists(@href) and not(exists(@tref)))">@tref or @href should exist, but not both</sch:assert>
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
        <sch:rule context="link[@href]">
            <sch:assert test="local-name(parent::node()) ne 'extent'">regular links must not be in the extent element</sch:assert>
        </sch:rule>
    </sch:pattern>
</sch:schema>