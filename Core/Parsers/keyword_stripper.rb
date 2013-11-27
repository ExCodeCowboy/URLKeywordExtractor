require 'treat'
include Treat::Core::DSL
class KeywordStripper

  def initialize objectLookupActions,outputAction
    @lookupActions = objectLookupActions
    @outputAction = outputAction
  end

  def strip_keywords record
    keywords = []
    @lookupActions.each {|action|
      data = action.call(record)
      keywords += extract_keywords_from_object(data)
    }
    @outputAction.call(record,keywords.uniq.select{|w|w.length>2})
    record
  end

  def extract_keywords_from_object(data)

    return data.flat_map {|i|extract_keywords_from_object(i)} if data.is_a? Array
    return data.flat_map {|k,v|extract_keywords_from_object(v)} if data.is_a? Hash
    stringdata = phrase data
    tokens = stringdata.tokenize :ptb

    words = tokens.words.map { |w| w.to_s.downcase }
    stemmed = words.stem :uea
    keywords = stemmed
  end

  def get_additional_keywords keyword
    keyword = word keyword


    hyponyms = keyword.hyponyms
    hypernyms = keyword.hypernyms
    synonyms = keyword.synonyms

    #p "Hyponyms(not used): " + hyponyms.join(",")
    #p "Hypernyms(not used): " + hypernyms.join(",")
    #p "Synonyms(phrases not used: " + synonyms.join(",")

    return synonyms.select {|x|!(/ /=~ x)} #strip multi-word
  end

  # To change this template use File | Settings | File Templates.
end