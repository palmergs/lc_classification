module LcClassification
  class Lookup

    LOOKUP_REGEX = /^([A-Za-z]{1,2})(\d+)[.]?(\d+)?/

    DATA_PATH = 'data/library-of-congress-classification.txt'

    attr_reader :prefix_hash

    def initialize path = DATA_PATH
      @prefix_hash = Hash.new
      reader = Reader.new(path)
      reader.read do |new_node|
        if new_node
          node = prefix_hash[new_node.prefix]
          if node
# p "#{ node.prefix }:#{ node.to_s }"
# p "#{ new_node.prefix }:#{ new_node.to_s }"
            node.insert(new_node)
          else
            root_node = LcClassification::Node.new(new_node.prefix,
                LcClassification::Value.new(0),
                LcClassification::Value.new(9999),
                new_node.prefix)
p "roo:#{ root_node.to_s }"
p "new:#{ new_node.to_s }"
            root_node.insert(new_node)
            prefix_hash[new_node.prefix] = root_node
          end
        end
      end
    end

    def find value
      return nil unless value
      match = LOOKUP_REGEX.match(value.to_s.strip)
      if match
        prefix = match[1]
        root = prefix_hash[prefix]
        root.find(Value.new(match[2].to_i, subvalue: match[3].to_i))
      else
        nil
      end
    end

    def to_s
      arr = []
      prefix_hash.each_pair do |key, root|
        arr << "#{ key } = #{ root.to_s }"
      end
      arr.join("\n")
    end
  end
end
