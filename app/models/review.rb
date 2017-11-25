class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  validates_presence_of :rating, :description, :reservation_id
   validate :status
  private 

  def status
    if self.reservation
      if self.reservation.status == "pending" || self.reservation.checkout > Date.today
        errors.add(:guest_id, "Cannot review yet")
      end
    end
  end
end