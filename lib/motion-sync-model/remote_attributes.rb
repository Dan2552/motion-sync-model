module SyncModel
  module RemoteAttributes

    def attributes
      attributes = super
      remote_attrs = [:id, :remote_id, :remote_updated_at, :remote_created_at]

      attributes.each do |a|
        if a.to_s.end_with?("_id") && (!a.to_s.start_with?("remote_"))
          remote_attrs << "remote_#{a}".to_sym unless remote_attrs.include? "remote_#{a}".to_sym
        end
      end

      remote_attrs.each do |name|
        make_attribute_getter_and_setter(name)
      end
      attributes
    end

  end

end
