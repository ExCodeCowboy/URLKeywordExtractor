class SimpleIDExtractor
  def get_identifier record
    ip = record[:ip_address]
    agent = record[:agent] || "unknown"
    (ip+agent).hash
  end

  def add_identifier record
    record[:id] = get_identifier record
    record
  end
end