class IgnoredUser < ActiveRecord::Base
  validates :user_id, uniqueness: :true
end
