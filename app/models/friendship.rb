class Friendship < ActiveRecord::Base
  belongs_to :user
  belongs_to :host, :class_name => "User"
end
