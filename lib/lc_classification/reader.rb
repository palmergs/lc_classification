module LcClassification



  class Reader

    REGEX = /^([A-Z]{1,2})([(]?\d+[.]?\d*[)]?)([-]([(]?\d+[.]?\d*[)]?)[.]?(\d+)?)?\s+(.*)/

    attr_reader :path

    def initialize path
      @path = path
    end

    def read
      last_match = nil
      File.open(path) do |f|
        while line = f.gets
          tmp = line.strip
          match = REGEX.match(tmp)
          if match
            yield(node_from_match(last_match)) if last_match
            last_match = match.to_a
          elsif is_continuation?(tmp) && last_match
            last_match[6] += " #{ tmp }"
          elsif last_match
            yield(node_from_match(last_match))
            last_match = nil
          end
        end
      end
      yield(node_from_match(last_match))
    end

    def node_from_match match
      return nil unless match && match.length > 6
      prefix = match[1]
      lo = match[2]
      hi = match[4] ? match[4] : match[2]
      description = match[6]
      Node.new(prefix, LcClassification::Value.lo_value(lo), LcClassification::Value.hi_value(hi), description)
    end

    def unparsed_line?
      !@continuation.empty?
    end

    def is_continuation? line
      if line.empty? ||
          line.start_with?("Subclass ") ||
          line.start_with?("CLASS ") ||
          line.start_with?("LIBRARY OF CONGRESS ")
        false
      else
        true
      end
    end

    def append_continuation line
      @continuation = @continuation + ' ' + line
    end
  end
end
