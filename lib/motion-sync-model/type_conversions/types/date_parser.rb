module SyncModel
  class DateParser

    def initialize obj
      @obj = obj
    end

    def is_str_date?
      @obj.respond_to?(:match) && !(@obj.match(/(([0-9]{4}-[0-9]{2}-[0-9]{2})|[0-9]{2}:[0-9]{2}:[0-9]{2})/).nil?)
    end

    def parse
      if is_str_date?
        formatter = NSDateFormatter.new
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        date = formatter.dateFromString(@obj)
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZZ"
        date ||= formatter.dateFromString(@obj)
        return date
      end

      Time.dateWithTimeIntervalSince1970(@obj)
    end

  end
end
