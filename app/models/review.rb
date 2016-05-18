class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  
  validates_presence_of :rating, :description, :reservation_id
  validate :res_accepted
  
  private
    def res_accepted
      errors.add(:reservation_id, "invalid reservation") unless Reservation.exists?(reservation_id) && Reservation.find(reservation_id).status == "accepted" && Reservation.find(reservation_id).checkout < Date.today
    end
      


end