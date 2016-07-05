module LcClassification
  class Lookup
    extend Singleton

    attr_reader :prefix_hash

    def initialize
      @prefix_hash = Hash.new
      reader = Reader.new('data/library-of-congress-classification.txt')
      reader.read do |new_node|
        if new_node
          node = prefix_hash[new_node.prefix]
          if node
            node.insert(new_node)
          else
            prefix_hash[new_node.prefix] = new_node
          end
        end
      end
    end
  end
end
