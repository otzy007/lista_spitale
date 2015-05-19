$SPECIALITIES = {
  'urgenta' => 'Emergency_medicine',
  'reumatismale' => 'Rheumatology',
  'urologie' => 'Urology',
  'boli cardiovasculare' => 'Cardiology',
  'cardiologie' => 'Cardiology',
  'nutritie' => 'Nutrition',
  'oncologic' => 'Oncology',
  'oncologie' => 'Oncology',
  'gastroenterologie' => 'Gastroenterology',
  'hepatologie' => 'Hepatology',
  'neurochirurgie' => 'Neurosurgery',
  'anestezie' => 'Anaesthetics',
  'chirurgie plastica' => 'Plastic_surgery',
  'oro-maxilo-faciala' => 'Oral_and_maxillofacial_surgery',
  'obstetrica si ginecologie' => 'Obstetrics_and_gynaecology',
  'obstetrica-ginecologie' => 'Obstetrics_and_gynaecology',
  'oftalmologice' => 'Ophthalmology',
  'pediatrie' => 'Pediatrics',
  'copii' => 'Pediatrics',
  'pulmonare' => 'Pulmonology',
  'tbc' => 'Pulmonology',
  'pneumoftiziologie' => 'Pulmonology',
  'ortopedie' => 'Orthopedic_surgery',
  'neurologie' => 'Neurology',
  'psihiatrie' => 'Psychiatry',
  'endocrinologie' => 'Endocrinology',
  'recuperare' => 'Physical_medicine_and_rehabilitation',
  'neuropsihiatrie' => 'Neuropsychiatry',
  'geriatrie' => 'Geriatrics',
  'nefrologie' => 'Nephrology',
  'infectioase' => 'Infectious_disease_(medical_specialty)'
}

def add_speciality(name, hospital_link)
  $SPECIALITIES.collect do |k, v|
    if ActiveSupport::Inflector.transliterate(name.downcase).include?(k)
      [
        hospital_link,
        RDF.type,
        RDF::URI.new("http://dbpedia.org/page/#{v}")
      ]
    end
  end.compact
end
