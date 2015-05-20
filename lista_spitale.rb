require 'rdf'
require 'rdf/n3'
require 'spreadsheet'
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

def import_spitale
  Spreadsheet.client_encoding = 'UTF-8'
  book = Spreadsheet.open 'lista-spitalelor-publice-ordonate-alfabetic.xls'

  sheet1 = book.worksheet 0
  counter = 0

  RDF::N3::Writer.open("lista_spitale.n3", :prefixes =>  $prefixes) do |writer|
    RDF::N3::Writer.open("clasificari_spitale.n3", :prefixes =>  $prefixes) do |clasif_writer|
      sheet1.to_enum.drop(1).each do |row|
        counter += 1

        # break if counter == 104

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


        # spital_in_judet
        if row[4] && row[4] != 'RETEA SANITARA PROPR'
          graph << [
            hospital_link,
            VCARD.region,
            RDF::URI.new("http://opendata.cs.pub.ro/resource/#{row[4].gsub(' ', '_')}_Judet")
          ]
        end

        # clasificare
        if row[2]
          clasif = row[2].gsub('.', '')
          clasif_link = RDF::URI.new("http://opendata.cs.pub.ro/resource/Clasificare_Spital_#{clasif.gsub(' ', '_')}")

          clasif_writer << RDF::Graph.new << [
            clasif_link,
            RDFS.label,
            clasif
          ] << [
            clasif_link,
            RDF.type,
            RDF::URI.new("http://opendata.cs.pub.ro/property/clasificare_spital")
          ]

          graph << [
            hospital_link,
            RDF::Vocabulary.new('http://opendata.cs.pub.ro/property/')['clasificare_spital'],
            clasif_link
          ]
        end
        # # detalii organizare
        if row[5]
          graph << [
            hospital_link,
            RDF::Vocabulary.new('http://opendata.cs.pub.ro/property/')['detalii_organizare_spital'],
            row[5]
          ]
        end
        #
        # # regiunea de dezvoltare
        graph << [
          hospital_link,
          RDF::Vocabulary.new('http://opendata.cs.pub.ro/property/')['regiune_dezvoltare'],
          RDF::URI.new("http://opendata.cs.pub.ro/resource/Regiune_Dezvoltare_#{row[1]}")
        ]

        # specialitatea spitalului
        speciality = add_speciality(hospital_name, hospital_link)
p speciality
        speciality.each { |s| graph << s }

        writer << graph
      end
    end
  end
end

def properties
  RDF::N3::Writer.open("proprietati_spitale.n3", :prefixes =>  $prefixes) do |writer|
    writer << RDF::Graph.new << [
      RDF::URI.new("http://opendata.cs.pub.ro/property/clasificare_spital"),
      RDFS.label,
      'clasificare_spital'
    ] << [
      RDF::URI.new("http://opendata.cs.pub.ro/property/clasificare_spital"),
      RDF.type,
      RDF.property
    ]

    writer << RDF::Graph.new << [
      RDF::URI.new("http://opendata.cs.pub.ro/property/spital_in_judet"),
      RDFS.label,
      'spital_in_judet'
    ] << [
      RDF::URI.new("http://opendata.cs.pub.ro/property/spital_in_judet"),
      RDF.type,
      RDF.property
    ]

    writer << RDF::Graph.new << [
      RDF::URI.new("http://opendata.cs.pub.ro/property/detalii_organizare_spital"),
      RDFS.label,
      'detalii_organizare_spital'
    ] << [
      RDF::URI.new("http://opendata.cs.pub.ro/property/detalii_organizare_spital"),
      RDF.type,
      RDF.property
    ]

    writer << RDF::Graph.new << [
      RDF::URI.new("http://opendata.cs.pub.ro/property/regiune_dezvoltare"),
      RDFS.label,
      'regiune_dezvoltare'
    ] << [
      RDF::URI.new("http://opendata.cs.pub.ro/property/regiune_dezvoltare"),
      RDF.type,
      RDF.property
    ] << [
      RDF::URI.new("http://opendata.cs.pub.ro/property/regiune_dezvoltare"),
      OWL.sameAs,
      RDF::URI.new('http://dbpedia.org/page/Development_regions_of_Romania')
    ]
  end
end

properties
import_spitale
