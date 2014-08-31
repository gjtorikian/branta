class Repository < ActiveRecord::Base
  validates_presence_of :name, :owner, :name_with_owner, :hook_id

  has_many :deployments
end
