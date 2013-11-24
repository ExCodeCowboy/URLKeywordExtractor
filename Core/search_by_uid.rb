#/usr/bin/env ruby
require 'treat'
require 'pp'
require_relative '../Core/Parsers/keyword_stripper'
require_relative '../Core/DataAccess/memory_flat_file_hybrid'

include Treat::Core::DSL
uids = ARGF.read.split("\n")


data = MemoryFlatFileHybrid.new
uids.each do|uid|
  puts "\n"
  puts uid
  records = data.pull_records_by uid
  records.each {|i|puts i.pretty_inspect}
end
