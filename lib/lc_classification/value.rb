module LcClassification
  class Value
    include Comparable

    MAX_SUBVALUE = 999_999
    MIN_SUBVALUE = 1

    def self.parse_str str
      exclude = str.start_with?('(') && str.end_with?(')')
      arr = exclude ? str[1...-1].split('.') : str.split('.')
      val = Integer(arr[0])
      subval = arr.length == 2 ? Integer(arr[1]) : nil
      [ val, subval, exclude ]
    end

    def self.lo_value str
      val, subval, exclude = parse_str(str)
      new(val, subvalue: subval, exclude: (exclude ? :lo : nil))
    end

    def self.hi_value str
      val, subval, exclude = parse_str(str)
      new(val, subvalue: subval, exclude: (exclude ? :hi : nil))
    end

    # def self.search_value str
    #   val, subval, exclude = parse_str(str)
    #   new(val, subvalue: subval, exclude: nil)
    # end

    attr_reader :value, :subvalue, :exclude
    def initialize value, subvalue: nil, exclude: nil
      @exclude = [ :lo, :hi ].include?(exclude) ? exclude : nil
      if :lo == exclude
        @value = value
        @subvalue = subvalue ? subvalue + 1 : 1
      elsif :hi == exclude
        @value = (subvalue && subvalue > 0) ? value : value - 1
        @subvalue = subvalue ? subvalue - 1 : MAX_SUBVALUE
      else
        @value = value
        @subvalue = subvalue ? subvalue : 0
      end
    end

    def exclude_lo?
      :lo == exclude
    end

    def exclude_hi?
      :hi == exclude
    end

    def in? min, max
      self >= min && self <= max
    end

    def <=> rhs
      if rhs.value == value && rhs.subvalue == subvalue
        0
      elsif value < rhs.value || (value == rhs.value && subvalue < rhs.subvalue)
        -1
      else
        1
      end
    end

    def to_s
      if exclude_lo?
        if subvalue == 1
          "(#{ value })"
        else
          "(#{ value }.#{ subvalue - 1})"
        end
      elsif exclude_hi?
        if subvalue == MAX_SUBVALUE
          "(#{ value + 1})"
        else
          "(#{ value }.#{ subvalue + 1 })"
        end
      else
        subvalue == 0 ? "#{ value }" : "#{ value }.#{ subvalue }"
      end
    end
  end
end
