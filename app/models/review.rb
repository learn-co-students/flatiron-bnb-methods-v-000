class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  validates_presence_of :description, :rating, :reservation
  validate :checkout?

  def checkout?
    if reservation && reservation.checkout > Date.today
      errors.add(:checkout?, "error")
    end
  end
end
