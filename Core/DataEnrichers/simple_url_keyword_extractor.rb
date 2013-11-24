require 'uri'
require 'cgi'
require_relative '../../Core/Parsers/dictionary_splitter'

class SimpleUrlKeywordExtractor

  def initialize urlLookupAction,outputAction
    @dictionary_splitter = DictionarySplitter.new
    @excluded_path_keywords = %w(www com net edu html htm http https)
    @lookupAction = urlLookupAction
    @outputAction = outputAction
  end

  def enrich record
    url = @lookupAction.call(record)
    if url
      urlKeywords = parse_url(url)
      @outputAction.call(record,urlKeywords)
    end
    record
  end

  def parse_url url
    keywords = url.split('/').select {|s| !s.empty?}
                .map {|w|tokenize w}
                .flatten
                .map {|s| clean_keyword s}
                .select {|w|!@excluded_path_keywords.include?(w)}
    keywords = keywords.select{|w|!(/^[abcdef]{1,6}$/=~w)}
    return keywords
  end

  def clean_keyword raw_keyword
    return raw_keyword.downcase
  end

  def tokenize raw_string
    spaces = raw_string.split(' ')
    raw_matches = spaces.map {|w| w.scan(/[[:upper:]]?[[:lower:]]+|[[:upper:]]+/)}
              .flatten
    matches = raw_matches.map {|w| @dictionary_splitter.infer_spaces(w)}
              .flatten
    output_matches = (raw_matches.select{|w|w.length<10} + matches.select{|w|w.length>1}).uniq
    return output_matches
  end
end