#/usr/bin/env ruby
require 'treat'
require_relative '../Core/Parsers/keyword_stripper'
require_relative '../Core/DataAccess/memory_flat_file_hybrid'

include Treat::Core::DSL
keyword = ARGF.read.gsub "\n",''

keywordCollection = []
keyword_stripper = KeywordStripper.new([->x{x},->x{keyword_stripper.get_additional_keywords(x)}],->(x,y){keywordCollection=y})
keyword_stripper.strip_keywords keyword

data = MemoryFlatFileHybrid.new

ids = (keywordCollection.flat_map {|k|data.pull_ids_for k}).uniq
ids.each {|i|puts i}