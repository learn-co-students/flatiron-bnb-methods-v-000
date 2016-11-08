class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  has_one :listing, :through => :reservation
  validates_presence_of :description, :rating, :guest_id, :reservation_id
  validate :after_checkout
  
  def after_checkout
    if !self.reservation || self.reservation.status == "pending" || self.reservation.checkout > Date.today
      errors.add(:reservation_id, "reservation must have happened")
    end
  end

end
