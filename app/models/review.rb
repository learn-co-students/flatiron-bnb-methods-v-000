require 'pry'

class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates_presence_of :rating, :description
  validate :accepted_reservation, :checkout?

  def accepted_reservation
    if self.reservation && !self.reservation.status == "accepted"
      errors.add(:reservation, "not accepted")
    end
  end

  def checkout?
    unless reservation && reservation.checkout < Date.today
      errors.add(:reservation, "not accepted")
    end
  end
end
