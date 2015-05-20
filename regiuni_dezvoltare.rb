load 'lista_spitale.rb'

regions = {
  'B' => '/Bucharest-Ilfov_(development_region)',
  'NE' => '/Nord-Est_(development_region)',
  'NV' => '/Nord-Vest_(development_region)',
  'SE' => '/Sud-Est_(development_region)',
  'SV' => '/Sud-Vest_(development_region)',
  'C' => '/Centru_(development_region)',
  'S' => '/Sud_(development_region)',
  'V' => '/Vest_(development_region)'
}

RDF::N3::Writer.open("regiuni_dezvoltare.n3", :prefixes =>  $prefixes) do |writer|
  regions.each do |reg, link|
    region = RDF::URI.new("http://opendata.cs.pub.ro/resource/Regiune_Dezvoltare_#{reg}")

    writer << RDF::Graph.new << [
      region,
      RDFS.label,
      reg
    ] << [
      region,
      RDF.type,
      RDF::URI.new("http://opendata.cs.pub.ro/property/regiune_dezvoltare")
    ] << [
      region,
      RDF.type,
      RDF::URI.new('http://dbpedia.org/page/Development_regions_of_Romania')
    ] << [
      region,
      OWL.sameAs,
      RDF::URI.new("http://dbpedia.org/page#{link}")
    ]
  end
end
