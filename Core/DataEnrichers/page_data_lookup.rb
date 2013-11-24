require 'open-uri'
require 'uri'
require 'digest/sha2'

class PageDataLookup
  def initialize urlLookupAction,outputAction
    @lookupAction = urlLookupAction
    @outputAction = outputAction
  end


  def enrich record
    url = @lookupAction.call(record)
    if url != nil && url !=''
      urlid = get_page_id url
      page_data = lookupFromCache urlid, "processed"
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
    saveToCache(urlid,"processed",page_data)
    return page_data
  end

  def get_page_id url
    (Digest::SHA256.new << url).to_s.slice(0,10)
  end

  def lookupFromCache(urlid,prefix)
    file_name = 'cache/'+prefix+urlid+".cache"
    file_name = File.join(File.expand_path(File.dirname(__FILE__)),file_name)
    page_data = nil
    if File.exist? file_name
      page_data = File.open(file_name, "rb") {|f| Marshal.load(f)}
    end
    return page_data
  end

  def saveToCache(urlid,prefix,page_data)
    file_name = 'cache/'+prefix+urlid+".cache"
    file_name = File.join(File.expand_path(File.dirname(__FILE__)),file_name)
    File.open(file_name, "wb") {|io| Marshal.dump(page_data, io)}
  end



end