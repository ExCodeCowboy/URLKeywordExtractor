require 'uri'
require 'cgi'

class UrlKeywordExtractor
  def extract url

      uri = URI(url)

      query_keywords = parse_query uri
      path_keywords = parse_path uri

      return  {pathKeywords:path_keywords, queryKeywords:query_keywords}
  end

  def parse_query uri
    keywords = CGI.parse(uri.query).select {|k,v| !v.empty? }
                  .map {|k,v| [k , v.first.split(' ')]}
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

end