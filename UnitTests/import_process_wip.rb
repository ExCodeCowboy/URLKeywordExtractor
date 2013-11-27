require 'test/unit'
require 'benchmark'
require_relative '../Core/import_process'
require_relative '../Core/DataAccess/memory_flat_file_hybrid'


class ImportProcessWip < Test::Unit::TestCase

  def setup
    @import_process = ImportProcess.new
  end

  def teardown
    # Do nothing
  end

  def test_import_process_exists
    assert_not_nil @import_process
  end

  #def test_tiny_data_processes
    #@import_process.data_access.record_location = '../../UnitTests/TestIndex/'
    #@import_process.process_file '../SampleData/parsed_data.txt'
  #end


  def test_tiny_data_processes
    @import_process.data_access.record_location = '../../UnitTests/TestIndex/'
    @import_process.process_file '../SampleData/parsed_data_tiny.txt'
  end

end