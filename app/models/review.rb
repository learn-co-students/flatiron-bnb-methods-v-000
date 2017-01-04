class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  includes ActiveModel::Validations
  validates :rating, presence: true
  validates :description, presence: true
  validates_with ReservationComplete

end
