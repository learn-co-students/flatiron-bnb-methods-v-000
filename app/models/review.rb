class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates_presence_of :rating, :description, :reservation_id

  validate :stayed_at_listing?
    def stayed_at_listing?
      if self.reservation_id.is_a?(Integer)
        reservation = Reservation.find(self.reservation_id) 
        if !(reservation.status == "accepted" && reservation.checkout.to_date < Date.today)
          errors.add(:reservation, "You cannot review a listing you did not stay at.")
        end
      end
    end
end
