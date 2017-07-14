module AkerPermissionControllerConfig
  def self.included(base)
    base.instance_eval do

      check_authorization

      rescue_from CanCan::AccessDenied, AkerPermissionGem::NotAuthorized do |exception|
        respond_to do |format|
          format.api_json { head :forbidden, content_type: 'application/vnd.api+json' } if format.respond_to? :api_json          
          format.json { head :forbidden, content_type: 'text/html' }
          format.html { redirect_to root_path, alert: exception.message }
          format.js   { head :forbidden, content_type: 'text/html' }
        end
      end
    end
  end
end
