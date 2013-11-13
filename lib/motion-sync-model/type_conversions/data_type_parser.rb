module SyncModel

  class DataTypeParser

    def initialize obj
      @obj = obj
    end

    def parse
      if is_date?
        DateParser.parse(@obj)
      else
        @obj
      end
    end

    private

    def is_date?
      @obj.respond_to?(:match) && !(@obj.match(/(([0-9]{4}-[0-9]{2}-[0-9]{2})|[0-9]{2}:[0-9]{2}:[0-9]{2})/).nil?)
    end
  end

  class DateParser

    def self.parse(str)
      formatter = NSDateFormatter.new
      formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
      date = formatter.dateFromString(str)
      formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZZ"
      date ||= formatter.dateFromString(str)
      date
    end

  end
end
