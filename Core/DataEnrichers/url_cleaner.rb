require 'uri'
require 'cgi'

class UrlCleaner
  def initialize urlLookupAction,outputAction
    @lookupAction = urlLookupAction
    @outputAction = outputAction
  end

  def clean record
    url = @lookupAction.call(record)
    if url
      begin
       url = url.gsub(/[\| '’\}\{]/,'+')
       URI(url)
      rescue
       url = nil
      end
      @outputAction.call(record,url)
    end
    record
  end
end