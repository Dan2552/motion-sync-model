module SyncModel
  module TypeConversions

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods

      def attr_types
        @attr_types ||= {}
      end

      def attribute(name, options={})
        attributes << name
        attr_types[name] = options[:type]
        make_attribute_getter_and_setter(name)
      end

      def new(data={})
        data = type_to_database_value(data)
        super
      end

      def make_attribute_getter_and_setter(name)
        define_method(name) do |*args, &block|
          DataTypeParser.new(
            self.info[name],
            type: self.class.attr_types[name]
          ).parse
        end

        define_method((name + "=").to_sym) do |*args, &block|
          data_type = self.class.attr_types[name]
          self.info[name] = self.class.type_to_database_value(args[0], data_type)
        end
      end

      def type_to_database_value value, type=nil
        if value.is_a? Hash
          value.each {|k,v| value[k] = type_to_database_value(v, attr_types[k]) }
        elsif value.is_a? Array
          value.map {|v| type_to_database_value(v) }
        else
          if type == :date
            value = value.to_time if value.is_a? Date
            value = value.to_s if value.is_a? Time
          end
          value
        end
      end

    end
  end
end
