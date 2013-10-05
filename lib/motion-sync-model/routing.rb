module SyncModel
  class Routing

    def self.action(cls, params={})
      params = { action: params } if params.is_a? Symbol

      action = params.delete(:action) || :index
      cls = cls.class unless cls.is_a? Class
      action_location = ""
      action_location = "/#{action}" unless action.to_sym == :index
      html_params = build_params params
      action_location = "#{cls.to_s.pluralize.underscore}#{action_location}.json#{html_params}"
      "#{Settings.host}/#{action_location}"
    end

    def self.build_params params
      return "" if params.keys.count < 1
      str = "?"
      params.each_with_index do |(k, v), i|
        str = "#{str}#{i>0?"&":""}#{k}=#{v}"
      end
      str
    end

  end
end
