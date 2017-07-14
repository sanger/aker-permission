require "aker_permission_gem/version"
require 'cancan'

autoload :Ability, 'ability'
autoload :Accessible,      'concerns/accessible'
autoload :AkerPermissionControllerConfig, 'aker_permission_controller_config'
autoload :AkerPermissionClientConfig, 'aker_permission_client_config'

module AkerPermissionGem
  autoload :Ability,         'ability'
  autoload :Accessible,      'concerns/accessible'
  autoload :Permission,      'permission'

  class NotAuthorized < StandardError
  end
end
