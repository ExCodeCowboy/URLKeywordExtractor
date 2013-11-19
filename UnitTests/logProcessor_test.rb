require 'test/unit'
require 'benchmark'
require_relative '../Core/Parsers/log_reader.rb'


class LogProcessorTests < Test::Unit::TestCase

  attr_accessor :logReader

  def setup
    @log_reader = LogReader.new
  end

  def teardown
    # Do nothing
  end

  def test_log_reader_exists
    assert_not_nil @log_reader
  end

  def test_reads_the_right_number_of_records
    count = 0
    @log_reader.read("../SampleData/parsed_data_tiny.txt") do |record|
       count+=1
    end
    assert_equal(4,count)
  end

  def test_ignores_empty_records
    count = 0
    @log_reader.read("../SampleData/parsed_data_tiny_with_empty.txt") do |record|
      count+=1
    end
    assert_equal(3,count)
  end

  def test_parses_fields_correctly
    records = []
    @log_reader.read("../SampleData/parsed_data_tiny.txt") do |record|
       puts record[:url]
    end

  end
end