#/usr/bin/env ruby
require_relative '../Core/import_process'



process = ImportProcess.new
process.process_file '../SampleData/parsed_data.txt'

