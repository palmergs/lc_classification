module LcClassification
  class Node

    attr_accessor :parent
    attr_reader :min, :max, :prefix, :description, :children

    def initialize prefix, min, max, description
      @prefix = prefix
      @min = min
      @max = max
      @description = description
      @children = []
      @parent = nil
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

    def path
      if parent
        parent.path + [ self.description ]
      else
        [ self.description ]
      end
    end

    def insert new_node
p "X:#{ prefix }:#{ to_s }"
p "N:#{ new_node.prefix }:#{ new_node.to_s }"

      raise "New node (#{ new_node.prefix }) must share prefix (#{ prefix })" unless new_node.prefix == prefix
      raise "New node #{ new_node.prefix }#{ new_node.min }-#{ new_node.max } must be within current node #{ min }-#{ max }" unless new_node.min >= min && new_node.max <= max

      len = children.length
      if len == 0
        new_node.parent = self
        children << new_node
        0
      else
        recurse_insert(len / 2, len / 4, new_node)
      end
    end

    def find value
      len = children.length
      if len == 0
        value.in?(min, max) ? self : nil
      else
        recurse_find(len / 2, len / 4, value)
      end
    end

    def to_s
      '[' + ([ min.to_s ] + children.map(&:to_s) + [ max.to_s ]).join(', ') +']'
    end

    private

      def recurse_insert idx, delta, new_node
        node = children[idx]
p "C:#{ node.prefix }:#{ node.to_s }:#{ idx }:#{ delta }"
        if node.include?(new_node)
          # 1. if new_node is subset of existing node, append to existing node
          node.insert(new_node)
        elsif node.after?(new_node)
          # 2. insert before existing node; if previous node is before this node
          recurse_before(idx - delta, delta == 0 ? 1 : delta / 2, new_node)
        else
          # 3. insert before next node if next node is after this node
          recurse_after(idx + delta, delta == 0 ? 1 : delta / 2, new_node)
        end
      end

      def recurse_before idx, delta, new_node
        if idx == 0
          new_node.parent = self
          children.insert(0, new_node)
          return 0
        elsif children[idx - 1].before?(new_node)
          new_node.parent = self
          children.insert(idx, new_node)
          return idx
        else
          return recurse_insert(idx - delta, delta == 0 ? 1 : delta / 2, new_node)
        end
      end

      def recurse_after idx, delta, new_node
        if idx == children.length - 1 || children[idx + 1].after?(new_node)
          new_node.parent = self
          children.insert(idx + 1, new_node)
          return idx + 1
        else
          return recurse_insert(idx + delta, delta == 0 ? 1 : delta / 2, new_node)
        end
      end

      def recurse_find idx, delta, value
        node = children[idx]
        if value.in?(node.min, node.max)
          node.find(value) || self
        elsif value < node.min
          if idx > 0 && value > children[idx - 1].max
            self
          else
            recurse_find(idx - delta, delta == 0 ? 1 : delta / 2, value)
          end
        elsif value > node.max
          if idx < children.length - 1 && value < children[idx + 1].min
            self
          else
            recurse_find(idx + delta, delta == 0 ? 1 : delta / 2, value)
          end
        else
          self
        end
      end
  end
end
