require 'rdf'
require 'rdf/n3'
require 'spreadsheet'

Spreadsheet.client_encoding = 'UTF-8'
book = Spreadsheet.open 'lista-spitalelor-publice-ordonate-alfabetic.xls'

sheet1 = book.worksheet 0

RDF::N3::Writer.open("lista_spitale.n3") do |writer|
  sheet1.each do |row|
    # p row[3]
    graph = RDF::Graph.new << [
        RDF::URI.new("http://opendata.cs.pub.ro/resource/#{row[3]}".gsub(' ', '_')),
        RDF.type,
        RDF::URI.new("http://dbpedia.org/class/yago/HospitalsInRomania")
      ]

    graph << [
        RDF::URI.new("http://opendata.cs.pub.ro/resource/#{row[3]}".gsub(' ', '_')),
        RDF.type,
        RDF::URI.new("http://dbpedia.org/class/yago/Hospital103540595")
      ]
    graph << [
      RDF::URI.new("http://opendata.cs.pub.ro/resource/#{row[3]}".gsub(' ', '_')),
      RDF::Vocabulary.new('http://dbpedia.org/ontology/county/').label,
      RDF::URI.new("http://dbpedia.org/page/#{row[4]}")
    ]
    p graph.data.first
    writer << graph
  end
end
