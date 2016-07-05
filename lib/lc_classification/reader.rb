module LcClassification



  class Reader

    REGEX = /^([A-Z]{1,2})([(]?\d+[.]?\d*[)]?)([-]([(]?\d+[.]?\d*[)]?)[.]?(\d+)?)?\s+(.*)/

    attr_reader :path

    def initialize path
      @path = path
    end

    def read
      @continuation = ''
      File.open(path) do |f|
        while line = f.gets
          tmp = line.strip
          if is_continuation?(tmp)

          else
            match = REGEX.match(tmp)
          end
        end
      end
      yield(@continuation) if block_given?
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
