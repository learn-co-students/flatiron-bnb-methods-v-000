class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, :description, presence: :true

  validate :completed_booking


  private

    def completed_booking
      errors.add(:reservation_id, "Reservation does not exist") unless Reservation.exists?(reservation_id) && Reservation.find(reservation_id).status == "accepted" && Reservation.find(reservation_id).checkout < Date.today
    end  

end
