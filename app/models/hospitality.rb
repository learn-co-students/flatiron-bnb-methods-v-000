class Hospitality < ActiveRecord::Base
  belongs_to :user
  belongs_to :guest, :class_name => "User"
end
