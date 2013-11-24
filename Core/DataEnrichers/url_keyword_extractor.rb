require 'uri'
require 'cgi'
require_relative '../../Core/Parsers/dictionary_splitter'

class UrlKeywordExtractor

  def initialize urlLookupAction,outputAction
    @dictionary_splitter = DictionarySplitter.new
    @excluded_path_keywords = %w(www com net edu org html htm cgi bin index php frame iframe ashx)
    @lookupAction = urlLookupAction
    @outputAction = outputAction
  end

  def enrich record
    url = @lookupAction.call(record)

    if url
      begin
        urlKeywords = extract(url)
      rescue
      end
      @outputAction.call(record,urlKeywords)
    end

    record
  end

  def extract url, excluded_query_keys = []
      url||=''
      url = url.gsub(/[\| '’\}\{]/,'+')
      uri = URI(url)
      query_keywords = parse_query uri, excluded_query_keys
      path_keywords = parse_path uri
      return  {pathKeywords:path_keywords, queryKeywords:query_keywords}
  end

  def parse_query uri, excluded_query_keys
    query = CGI.parse(uri.query||'')
    keywords = query.select {|k,v| !v.empty? && !excluded_query_keys.include?(k)}
                  .map {|k,v| [tokenize(v.join(' '))]}
                  .flatten
                  .map {|s| clean_keyword s}
    #filter out probable hex vals
    keywords = keywords.select{|w|!(/^[abcdef]{1,6}$/=~w)}
    return keywords
  end

  def parse_path uri
    keywords = ((uri.host||'') + ' ' + (uri.path||'')).split('/').select {|s| !s.empty?}
                .map {|w|tokenize w}
                .flatten
                .map {|s| clean_keyword s}
                .select {|w|!@excluded_path_keywords.include?(w)}
    return keywords
  end

  def clean_keyword raw_keyword
    return raw_keyword.downcase
  end

  def tokenize raw_string
    spaces = raw_string.split(' ')
    raw_matches = spaces.map {|w| w.scan(/[[:upper:]0-9]?[[:lower:]0-9]+|[[:upper:]0-9]+/)}
              .flatten.select{|w|!(/[0-9][A-Za-z]*/=~w)} #trying to strip some of the Base 64 noise out
    matches = raw_matches.map {|w| @dictionary_splitter.infer_spaces(w)}
              .flatten
    output_matches = (raw_matches.select{|w|w.length<10} + matches.select{|w|w.length>1}).uniq
    return output_matches
  end
end