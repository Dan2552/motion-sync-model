module SyncModel
  class Json
    def self.parse string
      parsed = BW::JSON.parse string
      localize(convert_types(parsed))
    end

    def self.localize object
      if object.class == Array
        return object.map { |child| localize(child) }
      end

      local_object = object.dup

      object.each do |key, value|
        if key.end_with?("_id") || key == "id"
          local_object.delete(key)
          local_object["remote_#{key}"] = value
        end
      end

      local_object["remote_updated_at"] = local_object.delete("updated_at")
      local_object["remote_created_at"] = local_object.delete("created_at")
      local_object
    end

    def self.foreignize object
      if object.class == Array
        return object.map { |child| foreignize(child) }
      end

      foreign_object = object.dup

      object.each do |key, value|
        if key.start_with? "remote_"
          stripped_key = key[7..-1].to_sym
          mobile_value = object[stripped_key]
          foreign_object[stripped_key] = value
          foreign_object["mobile_#{stripped_key}"] = mobile_value
          foreign_object.delete(key)
        end
      end

      foreign_object
    end

    private

    def self.convert_types object
      if object.class == Array
        return object.map { |child| convert_types(child) }
      end

      converted_object = object.dup

      object.each do |key, value|
        converted_object[key] = DataTypeParser.new(value).parse
      end

      converted_object
    end
  end
end
