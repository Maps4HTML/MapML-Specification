<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process" xmlns:xs="http://www.w3.org/2001/XMLSchema-datatypes" >
    <sch:pattern >
        <sch:rule context="*">
            <!-- I could not figure out how to ban xmlns="", but that might be a bit extreme anyway -->
            <sch:report test="exists(namespace::node()[name() ne  'xml'])">Namespaces are not allowed in MicroXML</sch:report>
        </sch:rule>
    </sch:pattern>
</sch:schema>