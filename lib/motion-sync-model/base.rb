module SyncModel
  class Base < NanoStore::Model
    extend RemoteAttributes
    include TypeConversions
    include ActiveRecordLike
    include Relations

    def to_hash
      attributes.clone
    end

    def payload
      BW::JSON.generate({ self.class.to_s.downcase => Json.foreignize(to_hash) })
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

module ActiveRecord
  class Base < SyncModel::Base
  end
end
