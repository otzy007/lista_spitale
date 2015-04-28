load 'lista_spitale.rb'

regiuni =

RDF::N3::Writer.open("regiuni_dezvoltare.n3", :prefixes =>  $prefixes) do |writer|
  ['B', 'NE', 'NV', 'SE', 'SV', 'C', 'S', 'V'].each do |reg|
    writer << RDF::Graph.new << [
      RDF::URI.new("http://opendata.cs.pub.ro/resource/Regiune_Dezvoltare_#{reg}"),
      RDFS.label,
      reg
    ] << [
      RDF::URI.new("http://opendata.cs.pub.ro/resource/Regiune_Dezvoltare_#{reg}"),
      RDF.type,
      RDF::URI.new("http://opendata.cs.pub.ro/property/regiune_dezvoltare")
    ]
  end
end
