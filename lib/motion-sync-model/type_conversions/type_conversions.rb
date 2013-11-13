module SyncModel
  module TypeConversions

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods

      def attribute(name)
        attributes << name
        make_attribute_getter_and_setter(name)
      end

      def new(data={})
        data.each { |k,v| data[k] = type_to_database_value(v) }
        super
      end

      def make_attribute_getter_and_setter(name)
        define_method(name) do |*args, &block|
          DataTypeParser.new(self.info[name]).parse
        end

        define_method((name + "=").to_sym) do |*args, &block|
          self.info[name] = self.class.type_to_database_value(args[0])
        end
      end

      def type_to_database_value value
        value = value.to_time if value.is_a? Date
        value = value.to_s if value.is_a? Time
        value
      end

    end
  end
end
