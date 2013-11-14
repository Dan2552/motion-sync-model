module SyncModel
  module ActiveRecordLike

    def self.included(base)
      base.extend(ClassMethods)
    end

    def attributes
      hash = {}
      self.class.attributes.each do |a|
        hash[a] = self.send(a)
      end
      hash
    end

    def attributes= set_attrs
      set_attrs.each do |a, new_value|
        self.send("#{a}=", new_value) if respond_to?("#{a}=")
      end
    end

    def update set_attrs
      self.attributes = set_attrs
      save
    end

    def save
      self.id = IdCount.next unless self.id
      super
    end

    def save!
      save
    end

    def == compare
      self.class == compare.class && self.id == compare.id
    end

    module ClassMethods

      #this is actually where()
      def find *args
        if args[0].is_a? Hash
          args[0] = type_to_database_value(args[0])
          args[0].each do |k,v|

            # Convert range to Nanostore format e.g.
            # TimeEntry.where(time: (one..two))
            # to
            # TimeEntry.where(time: { NSFGreaterThan => one, NSFLessThan => two })
            if v.is_a? Range
              args[0][k] = { NSFGreaterThan => v.first, NSFLessThan => v.last }
            end
          end
        end
        super
      end

      alias_method :where, :find
      def find *args
        where(*args).first
      end

      def delete_all
        all.each { |r| r.delete }
      end

      def destroy_all
        delete_all
      end

      def first
        all.first
      end

      def last
        all.last
      end

      def validates *args
        #TODO: stubbed
      end

      def accepts_nested_attributes_for *args
        #TODO: stubbed
      end

      def before_create *args
        #TODO: stubbed
      end
    end
  end
end
