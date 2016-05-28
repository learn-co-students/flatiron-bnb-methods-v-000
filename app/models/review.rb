require_relative 'review_validity.rb'

class Review < ActiveRecord::Base
  #include ActiveModel::Validations
  #ReviewValidity

  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  
  validates :description, presence: true
  validates :rating, presence: true
  validates :reservation, presence: true

  # Validating that a review can only be made if it has an accepted review 
  # and reservation has been checkedout
  validate :valid_status
  validate :checkedout?

  def valid_status 
    if reservation && reservation.status != "accepted" 
      errors.add(:reservation, "Invalid status for reservation review")
    end
  end

  def checkedout?
    if reservation && reservation.checkout > Time.now
      errors.add(:reservation, "Invalid because checkout for reservation has not happened yet")
    end
  end
end
