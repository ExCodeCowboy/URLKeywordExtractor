require_relative 'Parsers/log_reader'
require_relative 'DataEnrichers/page_data_lookup'
require_relative 'DataEnrichers/url_keyword_extractor'
require_relative 'DataEnrichers/simple_id_extractor'
require_relative 'DataEnrichers/url_cleaner'
require_relative 'Parsers/keyword_stripper'
require_relative 'DataAccess/memory_flat_file_hybrid'

class ImportProcess

  attr_accessor :data_access

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

   #Keyword Extraction
   @keyword_stripper = KeywordStripper.new([#->x{x[:url_data]},
                                            ->x{x[:url_uri_keywords]},
                                            #->x{x[:referrer_data]},
                                            ->x{x[:referrer_uri_keywords]}],
                                            ->(x,y){x[:keywords]=y})

   @data_access = MemoryFlatFileHybrid.new


  end

  def process_file filename
    @data_access.purge_old_data
    mutex = Mutex.new
    threads = []
    count = 0
    @log_reader.read(filename) do |record|
      count+=1
      p count
      t = Thread.new { process_record record, mutex}
      threads.push(t)
      if threads.length > 10
        t = threads.shift
        t.join
      end
    end
    threads.each {|wt|wt.join()}
    @data_access.snapshot_data

  end

  def process_record record, mutex
    #clean input - very crude
    record = @url_cleaner.clean record
    record = @referrer_cleaner.clean record

    #Add has based Id
    record = @id_creator.add_identifier record

    #back fill page data
    #record = @url_lookup.enrich record
    #record = @referrer_lookup.enrich record

    #tockenize urls
    record = @url_keywords.enrich record
    record = @referrer_keywords.enrich record

    #Tokenize, stem and extract all unique keywords from parser records
    mutex.synchronize do
      record = @keyword_stripper.strip_keywords record
      #persist records
      @data_access.save_record record
    end
  end


end