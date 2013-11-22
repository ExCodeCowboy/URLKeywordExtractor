require 'test/unit'
require 'benchmark'
require_relative '../Core/DataEnrichers/simple_id_extractor'
require_relative '../Core/Parsers/log_reader'

class SimpleIDExtractor_test  < Test::Unit::TestCase

  def setup
    @id_extractor = SimpleIDExtractor.new
  end

  def teardown
    # Do nothing
  end

  def test_id_extractor_exists
    assert_not_nil @id_extractor
  end

  def test_id_extractor_adds_id_to_hash
    record = {}
    record[:agent]='IE 9'
    record[:ip_address]='127.0.0.1'

    @id_extractor.add_identifier(record)

    assert_not_nil(record[:id])
  end

  def test_id_extractor_creates_no_collisions
    collision = false
    collision_check = {}
    log_reader = LogReader.new
    log_reader.read("../SampleData/parsed_data.txt") do |record|
      if record[:ip_address] != nil
        record[:agent] ||= "unknown"
        new_id = @id_extractor.get_identifier record
        if collision_check.has_key? new_id
          oldrecord = collision_check[new_id]
          if oldrecord[:ip_address] != record[:ip_address]
            assert_fail_assertion("collision on ip encountered")
          end

          if oldrecord[:agent] != record[:agent]
            assert_fail_assertion("collision on agent encountered")
          end
        else
          collision_check[new_id]=record
        end
      end
    end
  end

end
