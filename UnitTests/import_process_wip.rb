require 'test/unit'
require 'benchmark'
require_relative '../Core/import_process'


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

  def test_tiny_data_processes
    @import_process.process_file '../SampleData/parsed_data.txt'
  end


end