module AkerPermissionGem
  class Permission < ApplicationRecord
    belongs_to :accessible, polymorphic: true
  end
end