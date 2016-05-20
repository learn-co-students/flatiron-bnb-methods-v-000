class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates_presence_of :description, :rating
  validate :invalid_requirements?

  protected

  def invalid_requirements?
    if !reservation || reservation.checkout > Date.today || reservation.status != "accepted"
      errors.add(:guest, "cannot be provided at this time.")
    end
  end
end
