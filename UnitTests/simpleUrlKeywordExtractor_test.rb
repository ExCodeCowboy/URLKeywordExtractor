require 'test/unit'
require 'benchmark'
require_relative '../Core/DataEnrichers/simple_url_keyword_extractor'


class UrlKeywordExtractorTests < Test::Unit::TestCase
  #Test URLS
  SIMPLE_TEST_URL ='https://www.google.com/search?q=What+is+the+weather+like+on+mars&aqs=chrome.0.69i57j0l3j69i62l2.10643j0&sourceid=chrome&ie=UTF-8'
  CASE_ONLY_TEST_URL = 'https://www.google.com/search?q=WhatIsTheWeatherLikeOnMars&aqs=chrome.0.69i57j0l3j69i62l2.10643j0&sourceid=chrome&ie=UTF-8'
  DIFFICULT_TEST_URL = 'https://www.google.com/search?q=whatistheweatherlikeonmars&aqs=chrome.0.69i57j0l3j69i62l2.10643j0&sourceid=chrome&ie=UTF-8'
  REAL_DATA_TEST_URL = 'http://national.citysearch.com/profile/605382452/murrieta_ca/real_goods_solar.html?publisher=freedirectoryguide&raid=89308492&c=000700000960d3614b4154491ca2957ced3f4fd342&cgrefid=678007fdb555440689670c6c68fc59b1'

  #Expected Test Results
  EXPECTED = ["google",
              "search",
              "q",
              "what",
              "is",
              "the",
              "weather",
              "like",
              "on",
              "mars",
              "aqs",
              "chrome",
              "i",
              "j",
              "l",
              "sourceid",
              "ie",
              "utf",
              "qs",
              "source",
              "id"]

  attr_accessor :extractor

  def setup
    @extractor =  SimpleUrlKeywordExtractor.new(->x{x},->(x,y){x[:output]=y})
  end

  def teardown
    # Do nothing
  end

  def test_extractor_exists
    assert_not_nil @extractor
  end

  def test_extractor_returns_hash
    keywords = @extractor.parse_url SIMPLE_TEST_URL
    assert keywords.kind_of?(Array)
  end

  def test_correct_for_simple_test_path
    result = @extractor.parse_url SIMPLE_TEST_URL
    assert_equal(EXPECTED.sort!, result.sort!)
  end

  def test_correct_for_simple_test
    result = @extractor.parse_url SIMPLE_TEST_URL
    assert_equal(EXPECTED.sort!, result.sort!)
  end

  def test_correct_for_case_only_test
    result = @extractor.parse_url CASE_ONLY_TEST_URL
    assert_equal(EXPECTED.sort!, result.sort!)
  end

  def test_correct_for_difficult_test
    result = @extractor.parse_url DIFFICULT_TEST_URL
    assert_equal(EXPECTED.sort!, result.sort!)
  end

  def test_real_world_url
    result = @extractor.parse_url REAL_DATA_TEST_URL
    p result
  end
end