class LogReader

    def initialize
      @current_record = {}
      @key_lookup = {"ip"=>:ip_address,"r"=>:referrer,"u"=>:url,"ua"=>:agent}
    end

   def read file_name
     IO.foreach(file_name) do |line|
       process_line line do |record|
         yield record
       end
     end
   end

   def process_line line
      if /^\*{4}/ =~ line
        yield @current_record if @current_record.length > 0
        @current_record = {}
      end
      line.match(/^(.{1,2}): (.*)$/) do |m|
        key_name = m[1].downcase
        @current_record[@key_lookup[key_name]] = m[2] if (@key_lookup.has_key?(key_name) and !m[2].empty?)
      end
   end

end



