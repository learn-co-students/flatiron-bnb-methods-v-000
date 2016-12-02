class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates_presence_of :rating, :description
  validate :valid_reservation


  private
    def valid_reservation
      if !Reservation.exists?(reservation_id) || !Reservation.find(reservation_id).status == "accepted" || Reservation.find(reservation_id).checkout > Date.today
        errors.add(:valid_reservation, "Invalid reservation therefore you cannot review this listing.") 
      end
    end
end
