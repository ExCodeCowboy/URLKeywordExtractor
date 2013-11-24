require 'digest/sha2'

class SimpleIDExtractor
  def get_identifier record
    ip = record[:ip_address]
    agent = record[:agent] || "unknown"
    (Digest::SHA256.new << (ip+agent)).to_s.slice(0,10)
  end

  def add_identifier record
    record[:id] = get_identifier record
    record
  end
end