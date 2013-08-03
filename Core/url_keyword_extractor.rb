require 'uri'
require 'cgi'

class UrlKeywordExtractor
  def extract url, excluded_query_keys = []

      uri = URI(url)

      query_keywords = parse_query uri, excluded_query_keys
      path_keywords = parse_path uri

      return  {pathKeywords:path_keywords, queryKeywords:query_keywords}
  end

  def parse_query uri, excluded_query_keys
    query = CGI.parse(uri.query)
    keywords = query.select {|k,v| !v.empty? && !excluded_query_keys.include?(k) }
                  .map {|k,v| [tokenize(v.join(' '))]}
                  .flatten
                  .map {|s| clean_keyword s}
    return keywords
  end

  def parse_path uri
    keywords = uri.path.split('/').select {|s| !s.empty?}
                       .map {|s| clean_keyword s}
    return keywords
  end

  def clean_keyword raw_keyword
    return raw_keyword.downcase
  end

  def tokenize raw_string
    spaces = raw_string.split(' ')
    matches = spaces.map(){|w| w.scan(/[[:upper:]]?[[:lower:]]+|[[:upper:]]+/)}
              .flatten
    return matches
  end



end