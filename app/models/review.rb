class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :description, presence: true
  validates :rating, presence: true, numericality: {
            greater_than_or_equal_to: 0,
            less_than_or_equal_to: 5,
            only_integer: true
          }
  validates :reservation, presence: true

end
