class Review < ActiveRecord::Base
  
  validates :rating, :description, presence: true
  
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

end
