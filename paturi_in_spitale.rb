require 'rdf'
require 'rdf/n3'
require 'linkeddata'
require 'active_support/inflector'
require 'dbpedia'

load 'speciality.rb'

include RDF

 $prefixes = {
      cotext: "http://opendata.cs.pub.ro/context/",
      foaf: "http://xmlns.com/foaf/0.1/",
      rdfs: 'http://www.w3.org/2000/01/rdf-schema#',
      xsd: 'http://www.w3.org/2001/XMLSchema#',
      rdf: 'http://www.w3.org/1999/02/22-rdf-syntax-ns#',
      xml: 'http://www.w3.org/XML/1998/namespace',
      owl: 'http://www.w3.org/2002/07/owl#',
      sesame: 'http://www.openrdf.org/schema/sesame#',
      fn: 'http://www.w3.org/2005/xpath-functions#',
      vcard: VCARD.to_uri,
      ns1: 'http://opendata.cs.pub.ro/property/'
    }


paturi = [
  {
    uri: RDF::URI.new("http://opendata.cs.pub.ro/resource/paturi_spital_interne_2013"),
    label: 'Interne',
    count: '26198',
    type: RDF::URI.new("http://dbpedia.org/resource/Internal_medicine")
  }, {
    uri: RDF::URI.new("http://opendata.cs.pub.ro/resource/paturi_spital_chirurgie_2013"),
    label: 'Chirurgie',
    count: '20705',
    type: RDF::URI.new("http://dbpedia.org/resource/Surgery")
  }, {
    uri: RDF::URI.new("http://opendata.cs.pub.ro/resource/paturi_obstetrica_ginecologie_2013"),
    label: 'Obstetrica-Ginecologie',
    count: '8452',
    type: RDF::URI.new("http://dbpedia.org/resource/Obstetrics_and_gynaecology")
  }, {
    uri: RDF::URI.new("http://opendata.cs.pub.ro/resource/paturi_nou_nascuti_2013"),
    label: 'Nou nascuti',
    count: '4216',
    type: RDF::URI.new("http://dbpedia.org/resource/Pediatrics")
  }, {
    uri: RDF::URI.new("http://opendata.cs.pub.ro/resource/paturi_pediatrie_2013"),
    label: 'Pediatrie',
    count: '7580',
    type: RDF::URI.new("http://dbpedia.org/resource/Pediatrics")
  }, {
    uri: RDF::URI.new("http://opendata.cs.pub.ro/resource/paturi_boli_infectioase_2013"),
    label: 'Boli infectioase',
    count: '5422',
    type: RDF::URI.new("http://dbpedia.org/resource/Infectious_disease_(medical_specialty)")
  }, {
    uri: RDF::URI.new("http://opendata.cs.pub.ro/resource/paturi_pneumoftiziologie_2013"),
    label: 'Pneumoftiziologie',
    count: '9039',
    type: RDF::URI.new("http://dbpedia.org/resource/Pulmonology")
  }, {
    uri: RDF::URI.new("http://opendata.cs.pub.ro/resource/paturi_psihiatrie_neuropsihiatrie_2013"),
    label: 'Psihiatrie si neuropsihiatrie',
    count: '16359',
    type: RDF::URI.new("http://dbpedia.org/resource/Psychiatry"),
    type2: RDF::URI.new("http://dbpedia.org/resource/Neuropsychiatry")
  }, {
    uri: RDF::URI.new("http://opendata.cs.pub.ro/resource/paturi_oftalmologie_2013"),
    label: 'Oftalmologie',
    count: '1729',
    type: RDF::URI.new("http://dbpedia.org/resource/Ophthalmology")
  }, {
    uri: RDF::URI.new("http://opendata.cs.pub.ro/resource/paturi_orl_2013"),
    label: 'O.R.L',
    count: '2236'
  }, {
    uri: RDF::URI.new("http://opendata.cs.pub.ro/resource/paturi_neurologie_2013"),
    label: 'Neurologie',
    count: '5419',
    type: RDF::URI.new("http://dbpedia.org/resource/Neurology")
  }, {
    uri: RDF::URI.new("http://opendata.cs.pub.ro/resource/paturi_dermato_venerice_2013"),
    label: 'Dermato-venerice',
    count: '1548'
  }
]
RDF::N3::Writer.open("paturi_spitale.n3", :prefixes =>  $prefixes) do |writer|
  writer << RDF::Graph.new << [
    RDF::URI.new("http://opendata.cs.pub.ro/property/numar_paturi_spitale_2013"),
    RDFS.label,
    'numar_paturi_spital_2013'
  ] << [
    RDF::URI.new("http://opendata.cs.pub.ro/property/numar_paturi_spitale_2013"),
    RDF.type,
    RDF.property
  ]


  paturi.each do |p|
    graph = RDF::Graph.new << [
      p[:uri],
      RDFS.label,
      p[:label]
    ] << [
      p[:uri],
      RDF::Vocabulary.new('http://opendata.cs.pub.ro/property/')['numar_paturi_spitale_2013'],
      p[:count]
    ] << [
      p[:uri],
      RDF.type,
      RDF::URI.new('http://dbpedia.org/resource/Specialty_(medicine)')
    ] << [
      p[:uri],
      RDF.type,
      RDF::Vocabulary.new('http://opendata.cs.pub.ro/property/')['numar_paturi_spitale_2013']
    ]

    if p.key?(:type)
      graph << [
        p[:uri],
        RDF.type,
        p[:type]
      ]
    end

    if p.key?(:type2)
      graph << [
        p[:uri],
        RDF.type,
        p[:type2]
      ]
    end

    writer << graph
  end
end
