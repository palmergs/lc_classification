module LcClassification
  class Node

    attr_reader :min, :max, :prefix, :description, :children, :parent

    def initialize prefix, min, max, description
      @prefix = prefix
      @min = min
      @max = max
      @description = description
      @children = []
      @parent = nil
    end

    def insert lc_node
      len = children.length
      if len == 0
        children << lc_node
      else
        idx = len / 2
        recurse_insert(idx, lc_node)
      end
    end

    def include? node
      min <= node.min && max >= node.max
    end

    def before? node
      max < node.min
    end

    def after? node
      min > node.max
    end

    def insert new_node
      len = children.length
      if len == 0
        new_node.parent = self
        children << new_node
        0
      else
        recurse_insert(len / 2, new_node)
      end
    end

    def find value
      len = children.length
      if len == 0
        value_in?(value) ? self : nil
      else
        recurse_find(len / 2, value)
      end
    end

    private

      def recurse_insert idx, new_node
        node = childen[idx]
        if node.include?(new_node)
          # 1. if new_node is subset of existing node, append to existing node
          node.insert(lc_node)
        elsif node.after?(new_node)
          # 2. insert before existing node; if previous node is before this node
          recurse_before(idx, new_node)
        else
          # 3. insert before next node if next node is after this node
          recurse_after(idx, new_node)
        end
      end

      def recurse_before idx, new_node
        if idx == 0 || children[idx - 1].before?(new_node)
          new_node.parent = self
          children.insert(idx, new_node)
          return idx
        else
          return recurse_insert(idx / 2, new_node)
        end
      end

      def recurse_after idx, new_node
        if idx >= children.length || children[idx + 1].after?(new_node)
          new_node.parent = self
          children << new_node
          return children.length
        else
          return recurse_insert(idx + idx / 2, new_node)
        end
      end

      def recurse_find idx, value
        node = children[idx]
        if value.in?(node.min, node.max)
          node.find(value) || self
        else
          delta = idx / 2
          if delta == 0
            self
          elsif value < node.min
            recurse_find(idx - delta, value)
          else
            recurse_find(idx + delta, value)
          end
        end
      end
  end
end
