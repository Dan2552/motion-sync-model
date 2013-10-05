module SyncModel
  class Settings

    def self.host
      @host
    end

    def self.host= new_host
      @host = new_host
    end

    def self.auth_action= new_action
      @auth_action = new_action
    end

    def self.auth_action
      @auth_action
    end
  end
end
