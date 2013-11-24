require 'test/unit'
require 'benchmark'
require_relative '../Core/Parsers/keyword_stripper'

class KeywordStripper_test  < Test::Unit::TestCase

  def setup
    @keyword_stripper = KeywordStripper.new([->x{x[:url_data]},
                                             ->x{x[:url_uri_keywords]},
                                             ->x{x[:referrer_data]},
                                             ->x{x[:referrer_uri_keywords]}],
                                             ->(x,y){x[:keywords]=y})

  end

  def teardown

  end

  def test_keyword_stripper_exists
    assert_not_nil @keyword_stripper
  end

  def test_tokenization_of_sentence
    test = {:ip_address=>"237.203.55.247",
            :agent=>"Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.0; Trident/4.0; FunWebProducts; GTB7.2; SLCC1; .NET CLR 2.0.50727; Media Center PC 5.0; .NET CLR 3.5.30729; .NET CLR 3.0.30729; .NET4.0C; AskTbLMW2/5.12.2.16749)",
            :url=>"http://www.celebrity-gossip.net/style_beauty",
            :referrer=>"http://www.celebrity-gossip.net/paris-fashion-week-2011/leighton-meester-hits-dior-fashion-show-548770?utm_source=adon&utm_medium=cpc&utm_campaign=CelebrityGossip4_573066_268168_114051_301_none",
            :id=>-1704150487229384903,
            :url_data=>{:title=>"Celebrity-gossip.net", :headers=>"", :keywords=>"celebrity gossip, gossip girls, hollywood gossip, celebrities exposed, celebrity news, celeb photos, entertainment news", :description=>"Since 2003, Celebrity Gossip Blog featuring the latest celebrity scandals, hollywood gossip, and entertainment news including gossip girls."},
            :referrer_data=>{:title=>" Leighton Meester Hits Up Dior Fashion Show | Celebrity-gossip.net", :headers=>" Leighton Meester Hits Up Dior Fashion Show", :keywords=>"leighton meester, leighton meester news, leighton meester pictures, gossip girl, on set, celebrity gossip, hollywood news, paris fashion week, christian dior, show", :description=>"Leighton Meester arrives at the Christian Dior show for Paris Fashion Week"},
            :url_uri_keywords=>{:pathKeywords=>["celebrity", "gossip", "style", "beauty"], :queryKeywords=>[]},
            :referrer_uri_keywords=>{:pathKeywords=>["celebrity", "gossip", "paris", "fashion", "week", "leighton", "meester", "hits", "dior", "fashion", "show"], :queryKeywords=>["adon", "don", "cpc", "celebrity", "gossip", "none"]}}

    expected = %w(celebrity gossip girl hollywood expose new celeb photo entertainment since blog feature the latest scandal and include style beauty leighton meester hit up dior fashion show picture on set pare week christian arrive at for adon don cpc none)

    @keyword_stripper.strip_keywords(test)

    assert_equal expected,test[:keywords]
  end

  def test_other_keyword_lookup
    test_keyword = 'drug'
    @keyword_stripper.get_additional_keywords(test_keyword)
  end



end
