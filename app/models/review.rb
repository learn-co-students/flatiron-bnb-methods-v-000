class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates_presence_of :rating
  validates_presence_of :description
  validates_presence_of :reservation_id

end
