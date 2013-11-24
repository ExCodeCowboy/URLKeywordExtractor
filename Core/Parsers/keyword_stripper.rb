require 'treat'
include Treat::Core::DSL
class KeywordStripper



  def initialize objectLookupAction,outputAction
    @lookupAction = objectLookupAction
    @outputAction = outputAction
  end

  def strip_keywords record
    data = @lookupAction.call(record)
    data = data.join(' ') if data.is_a? Array
    data = data.values.join(' ') if data.is_a? Hash

    tokens = data.tokenize :ptb

    words = tokens.words.map {|w|w.to_s.downcase}
    stemmed = words.stem :uea

    keywords = stemmed.uniq

    @outputAction.call(record,keywords)

  end



  # To change this template use File | Settings | File Templates.
end