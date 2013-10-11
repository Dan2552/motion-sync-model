module SyncModel
  class Base < NanoStore::Model
    include ActiveRecordLike
    include Relations

    def to_hash
      attributes.clone
    end

    def payload
      BW::JSON.generate({ self.class.to_s.downcase => Json.foreignize(to_hash) })
    end

    def self.attributes
      attributes = super
      remote_attrs = [:id, :remote_id, :remote_updated_at, :remote_created_at]

      attributes.each do |a|
        if a.to_s.end_with?("_id") && (!a.to_s.start_with?("remote_"))
          remote_attrs << "remote_#{a}".to_sym unless remote_attrs.include? "remote_#{a}".to_sym
        end
      end

      remote_attrs.each do |name|
        unless attributes.include? name
          attributes << name

          define_method(name) do |*args, &block|
            self.info[name]
          end

          define_method((name + "=").to_sym) do |*args, &block|
            self.info[name] = args[0]
          end
        end
      end
      attributes
    end

    def self.update_or_create params
      if params.is_a? Array
        return params.map {|p| update_or_create(p) }
      end

      remote_id = params[:remote_id] || params["remote_id"]
      remote = find(remote_id: remote_id)

      if remote
        remote.update(params)
      else
        create(params)
      end
    end

    def self.get(params={}, &object)
      Network.get self, params do |response|
        fetched_object = nil

        if response && response.body
          begin
            json = Json.parse(response.body.to_str)
            fetched_object = update_or_create(json)
          rescue
            puts "Non-json response"
            fetched_object = nil
          end
        else
          #TODO: this shouldn't really be handled here
          App.alert("Request failed. Check your internet connection and try again.")
        end
        object.call(fetched_object != nil) if object
      end
    end

    def post(params={}, &object)
      Network.post self, params do |response|
        json = Json.parse(response.body.to_str)
        update(json)
        object.call if object
      end
    end
  end
end
