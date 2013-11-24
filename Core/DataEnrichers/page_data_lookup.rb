require 'open-uri'
require 'uri'
require 'digest/sha2'
require_relative '../../Core/DataAccess/file_access'

class PageDataLookup
  include FileAccess
  def initialize urlLookupAction,outputAction
    @lookupAction = urlLookupAction
    @outputAction = outputAction
  end


  def enrich record
    url = @lookupAction.call(record)
    if url != nil && url !=''
      urlid = get_page_id url
      page_data = lookupFromCache urlid
      page_data ||= pull_fresh_page(urlid,url)

      @outputAction.call(record,page_data)
    end
    record
  end

  def pull_fresh_page(urlid, url)
    page_data = {}
    begin
      source = open(url){|f|f.read}
      page_data[:title] = ''
      page_data[:headers] = ''
      page_data[:keywords] = ''
      page_data[:description] = ''
      source.match(/<title.*>(.*)<\/title>/) do |m|
        page_data[:title] += m[1]
      end
      source.match(/<meta[^>]*name="description"[^>]*content="([^"]*)"[^>]*>/) do |m|
        page_data[:description] +=m[1]
      end
      source.match(/<h1[^>]*>(.*)<\/h1>/) do |m|
        page_data[:headers] += m[1]
      end
      source.match(/<meta[^>]*name="keywords"[^>]*content="([^"]*)"[^>]*>/) do |m|
        page_data[:keywords] +=m[1]
      end
    rescue
      page_data[:title] = ''
      page_data[:headers] = ''
      page_data[:keywords] = ''
      page_data[:description] = ''
    end
    saveToCache(urlid,page_data)
    return page_data
  end

  def get_page_id url
    (Digest::SHA256.new << url).to_s.slice(0,10)
  end

  def lookupFromCache(urlid)
    load_from_file (filename_for urlid)
  end

  def saveToCache(urlid,page_data)
    save_to_file (filename_for urlid),page_data
  end

  def filename_for urlid
    make_file_name __FILE__, 'cache/processed'+urlid+".cache"
  end

end