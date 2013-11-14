module SyncModel
  class DataTypeParser

    attr_reader :type

    def initialize obj, options={}
      @obj = obj
      @type = options[:type]
    end

    def parse
      return DateParser.new(@obj).parse if type == :date
      @obj
    end

  end
end
