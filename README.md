## List of public hospitals in Romania

Scripts to parse the xls file with the public hospitals in Romania
`lista-spitalelor-publice-ordonate-alfabetic.xls` from http://data.gov.ro
and create a RDF N3 file.

## Getting Started

1. Install Ruby >= 1.9 if you don't have it yet.
The easiest way is with [rvm](http://rvm.io) with the command:

        \curl -sSL https://get.rvm.io | bash -s stable

2. Install dependecies by running:

        bundle install

3. Generate the auxiliary data

        ruby regiuni_dezvoltare.rb

4. Generate the data

        ruby lista_spitale.rb

5. Import first `regiuni_dezvoltare.n3`, then `proprietati_spitale.n3`, then
`clasificari_spitale.n3`. Finally you can import `lista_spitale.n3`.
