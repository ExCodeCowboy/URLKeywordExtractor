require 'test/unit'
require 'benchmark'
require_relative '../Core/DataEnrichers/page_data_lookup'

class PageDataLookup_test  < Test::Unit::TestCase

  def setup
    @page_data_lookup = PageDataLookup.new ->(x){x[:url]},->(x,y){x[:url_data]=y}
  end

  def teardown
    # Do nothing
  end

  def test_lookup_exists
    assert_not_nil @page_data_lookup
  end

  def test_lookup_returns_title
    record = {}
    record[:agent]='IE 9'
    record[:ip_address]='127.0.0.1'
    record[:url]='http://www.yahoo.com/'

    @page_data_lookup.enrich(record)
    p record[:url_data]
    assert_not_nil(record[:url_data][:title])
  end

  def test_lookup_returns_title_2
    record = {}
    record[:agent]='IE 9'
    record[:ip_address]='127.0.0.1'
    record[:url]='http://rubylearning.com/satishtalim/ruby_exceptions.html'

    @page_data_lookup.enrich(record)
    p record[:url_data]
    assert_not_nil(record[:url_data][:title])
  end



end
