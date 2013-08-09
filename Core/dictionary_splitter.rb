class DictionarySplitter
  # To change this template use File | Settings | File Templates.


  def initialize
     @word_cost = Hash.new
     file_location = File.join(File.expand_path(File.dirname(__FILE__)),"resources/words.txt")
     lines = open(file_location).readlines
     i=0
     lines.each {|w|@word_cost.store(w.strip,Math.log(i+=1))}
     @max_word = (@word_cost.keys.map {|w|w.size}).max
  end


  def infer_spaces(s)
    cost = [0]
    def best_match(i,s,cost)
        start =[0,i-@max_word].max
        candidates = cost[start..i].reverse
        candidate_costs = (0..(candidates.size-1)).map do |k|
          c = candidates[k]
          wstart =i-k
          wend = i
          word = if wend != wstart
                     s[wstart..wend]
                  else
                    s[wstart]
                  end
          current_word_cost = @word_cost[word]
          current_word_cost ||= 99999999999
          x=[c+current_word_cost,k]
        end
        return candidate_costs.min
    end
   #Build the cost array.

    (0..s.size-1).each do |i|
        c,k = best_match(i,s.downcase,cost)
        cost+=[c]
    end

    # Backtrack to recover the minimal-cost string.
    out = []
    i = s.size-1
    while i>0
        c,k = best_match(i,s.downcase,cost)
        c == cost[i]
        wstart = i-k
        wend = i
        word = s[wstart..wend]
        out+=[word]
        i -= (k + 1)

    end
    return  out.reverse

  end
end