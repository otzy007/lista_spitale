require 'rdf'
require 'rdf/n3'
require 'spreadsheet'
require 'linkeddata'
require 'active_support/inflector'

include RDF

Spreadsheet.client_encoding = 'UTF-8'
book = Spreadsheet.open 'lista-spitalelor-publice-ordonate-alfabetic.xls'

sheet1 = book.worksheet 0
counter = 0

prefixes = {
      cotext: "http://opendata.cs.pub.ro/context/",
      foaf: "http://xmlns.com/foaf/0.1/",
      rdfs: 'http://www.w3.org/2000/01/rdf-schema#',
      xsd: 'http://www.w3.org/2001/XMLSchema#',
      rdf: 'http://www.w3.org/1999/02/22-rdf-syntax-ns#',
      xml: 'http://www.w3.org/XML/1998/namespace',
      owl: 'http://www.w3.org/2002/07/owl#',
      sesame: 'http://www.openrdf.org/schema/sesame#',
      fn: 'http://www.w3.org/2005/xpath-functions#',
      vcard: 'http://www.w3.org/2001/vcard-rdf/3.0#',
      ns1: 'http://opendata.cs.pub.ro/property/'
    }

RDF::N3::Writer.open("lista_spitale.n3", :prefixes => prefixes) do |writer|
  sheet1.to_enum.drop(1).each do |row|
    counter += 1

    break if counter == 6

    hospital_name = ActiveSupport::Inflector.transliterate(row[3].tr("'\"“”", ""))
    hospital_link = RDF::URI.new("http://opendata.cs.pub.ro/resource/#{hospital_name.gsub(' ', '_')}")

    # types
    graph = RDF::Graph.new << [
        hospital_link,
        RDF.type,
        RDF::URI.new("http://dbpedia.org/class/yago/HospitalsInRomania")
      ]

    graph << [
      hospital_link,
      RDF.type,
      RDF::URI.new('http://schema.org/Hospital')
    ]

    # label
    graph << [
      hospital_link,
      RDFS.label,
      hospital_name
    ]

    # sameAs
    graph << [
        hospital_link,
        OWL.sameAs,
        RDF::URI.new("http://dbpedia.org/class/yago/Hospital103540595")
      ]

    # spital_in_judet
    graph << [
      hospital_link,
      RDF::Vocabulary.new('http://opendata.cs.pub.ro/property/')['spital_in_judet'],
      RDF::URI.new("http://opendata.cs.pub.ro/resource/#{row[4]}")
    ]
    
    p graph.data.first
    writer << graph
  end
end
