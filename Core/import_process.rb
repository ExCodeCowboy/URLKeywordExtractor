require_relative 'Parsers/log_reader'
require_relative 'DataEnrichers/page_data_lookup'
require_relative 'DataEnrichers/url_keyword_extractor'
require_relative 'DataEnrichers/simple_id_extractor'
require_relative 'DataEnrichers/url_cleaner'

class ImportProcess
  def initialize
   #Log Reader
   @log_reader = LogReader.new [->(x){x[:ip_address] == nil},->(x){x[:url]==nil && x[:referrer]==nil}]

   #Data Enrichment
   @id_creator = SimpleIDExtractor.new
   @url_lookup = PageDataLookup.new ->x{x[:url]}, ->(x,y){x[:url_data]=y}
   @referrer_lookup = PageDataLookup.new ->x{x[:referrer]}, ->(x,y){x[:referrer_data]=y}
   @url_keywords = UrlKeywordExtractor.new ->x{x[:url]},->(x,y){x[:url_uri_keywords]=y}
   @referrer_keywords = UrlKeywordExtractor.new ->x{x[:referrer]},->(x,y){x[:referrer_uri_keywords]=y}
   @url_cleaner = UrlCleaner.new ->x{x[:url]},->(x,y){x[:url]=y}
   @referrer_cleaner = UrlCleaner.new ->x{x[:referrer]},->(x,y){x[:referrer]=y}

  end

  def process_file filename
    @log_reader.read("../SampleData/parsed_data.txt") do |record|
      #clean input
      record = @url_cleaner.clean record
      record = @referrer_cleaner.clean record

      #Add Id
      record = @id_creator.add_identifier record

      #back fill page data
      record = @url_lookup.enrich record
      record = @referrer_lookup.enrich record



      #tockenize urls
      record = @url_keywords.enrich record
      record = @referrer_keywords.enrich record



      #tockenize all strings

      #stem all keywords

      #persist records
      p record
    end


  end


end