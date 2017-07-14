module AkerPermissionClientConfig
  def has_permission?(user_email, role)
    permissions.any? do |permission|
      permission.permitted == user_email && permission.permission_type.to_s==role.to_s
    end
  end

  def self.included(base)
    base.instance_eval do
      def self.authorize!(role, resource, user_email)
        # We need to have a resource that has the permissions included. If the paramter does not have
        # it, we obtain it again with the inclusion of the permissions
        if resource.respond_to?(:permissions)
          instance = resource
        else
          # If the parameter is an id:
          if resource.kind_of? String
            instance = where(id: resource).includes(:permissions).first
          else
            instance = where(id: resource.id).includes(:permissions).first
          end
        end
        unless instance.has_permission?(user_email, role)
          raise AkerPermissionGem::NotAuthorized.new("Not authorised to perform #{role} on #{instance.class.to_s} #{instance.id}")
        end
      end
    end
  end
end