require 'active_support/concern'

module AkerPermissionGem
  module Accessible
    extend ActiveSupport::Concern

    included do
      has_many :permissions, as: :accessible, :class_name => 'AkerPermissionGem::Permission'
      #after_create :set_default_permission

      def set_default_permission(user_email)
        self.permissions.create([{ permitted: user_email, permission_type: :read },
          { permitted: user_email, permission_type: :write },
          { permitted: 'world', permission_type: :read }])
      end

      # Takes a user_or_group as a string e.g. "blackbeard@sanger.ac.uk" and an access parameter e.g. :read
      def permitted?(email_or_group, access)
        self.permissions.exists?(permitted: email_or_group, permission_type: access.to_s)
      end
    end

  end
end