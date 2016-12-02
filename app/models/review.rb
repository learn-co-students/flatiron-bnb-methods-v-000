class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, :description, :reservation_id, presence: true

  validate :accepted?

  validate :checkout?

  def accepted?
    # binding.pry
    return if self.reservation.nil?
    unless self.reservation.status == "accepted"
        errors.add(:base, 'reservation status must be accepted before a review can occur')
    end
  end

  def checkout?
    return if self.reservation.nil?
    unless self.reservation.checkout < Time.now
        errors.add(:base, 'checkout must occur before review')
    end
  end
end
