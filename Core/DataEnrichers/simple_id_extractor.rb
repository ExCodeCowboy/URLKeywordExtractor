require 'digest/sha2'

class SimpleIDExtractor
  def get_identifier record
    ip = record[:ip_address]
    agent = record[:agent]
    digest = Digest::SHA256.new << ip+agent

    digest.to_s.slice(0,10)
  end

  def add_identifier record
    record[:id] = get_identifier record
  end
end