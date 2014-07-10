class Review < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"

  validates_presence_of :description, :rating
end
