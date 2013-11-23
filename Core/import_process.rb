require_relative 'Parsers/log_reader'
require_relative 'DataEnrichers/page_data_lookup'
require_relative 'DataEnrichers/simple_id_extractor'

class ImportProcess
  def initialize
   #Log Reader
   @log_reader = LogReader.new [->(x){x[:ip_address] == nil},->(x){x[:url]==nil && x[:referrer]==nil}]

   #Data Enrichment
   @id_creator = SimpleIDExtractor.new
   @url_lookup = PageDataLookup.new ->x{x[:url]}, ->(x,y){x[:url_data]=y}
   @referrer_lookup = PageDataLookup.new ->x{x[:referrer]}, ->(x,y){x[:referrer_data]=y}

  end

  def process_file filename
    @log_reader.read("../SampleData/parsed_data.txt") do |record|
      #Add Id
      record = @id_creator.add_identifier record

      #back fill page data
      record = @url_lookup.enrich record
      record = @referrer_lookup.enrich record

      #tockenize urls

      #tockenize all strings

      #stem all keywords

      #persist records

    end


  end


end