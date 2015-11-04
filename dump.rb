def dump_list(s, arr, level)
  arr.each_with_index do |el, i|
    puts "#{s} Level:#{level} Index:#{i} Element:#{el}"
    dump_list(s, el, level+1) unless el.is_a?(String)
  end
end


dump_list("Dump: ", ["a", "b", ["c", ["d", "e"], "f", ["g"]], "h", "i"], 1);
