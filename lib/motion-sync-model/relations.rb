module SyncModel
  module Relations

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def belongs_to symbol
        define_method(symbol) do |*args, &block|
          remote_id = send(remote_id_symbol(symbol))
          if remote_id
            return constant(symbol).find(remote_id: remote_id)
          end
          local_id = send(id_symbol(symbol))
          if local_id
            return constant(symbol).find(id: local_id)
          end
          nil
        end
      end

      def has_many symbol
        define_method(symbol.pluralize) do |*args, &block|
          puts "#{constant(symbol)}.where(#{remote_id_symbol(self.class)} => #{self.remote_id})"

          remotes = constant(symbol).where(remote_id_symbol(self.class) => self.remote_id)

          puts "#{constant(symbol)}.where(#{remote_id_symbol(self.class)} => nil, #{id_symbol(self.class)} => #{self.id}"
          locals = constant(symbol).where(
            #remote_id_symbol(self.class) => nil,
            id_symbol(self.class) => self.id
          )

          remotes + locals
        end
      end
    end

    private

    def remote_id_symbol obj
      "remote_#{id_symbol(obj)}".to_sym
    end

    def id_symbol obj
      "#{obj.to_s.singularize.underscore}_id".to_sym
    end

    def constant symbol
      symbol.singularize.camelize.constantize
    end

  end
end
