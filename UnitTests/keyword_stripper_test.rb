require 'test/unit'
require 'benchmark'
require_relative '../Core/Parsers/keyword_stripper'

class KeywordStripper_test  < Test::Unit::TestCase

  def setup
    @keyword_stripper = KeywordStripper.new ->x{x[:input]}, ->(x,y){x[:keywords]=y}
  end

  def teardown
    # Do nothing
  end

  def test_id_extractor_exists
    assert_not_nil @keyword_stripper
  end

  def test_tokenization_of_setence
    test = {}
    test[:input] = "How do you like the great cars and flies."

    @keyword_stripper.strip_keywords(test)

    assert_equal %w(how do you like the great car and fly),test[:keywords]
  end



end
