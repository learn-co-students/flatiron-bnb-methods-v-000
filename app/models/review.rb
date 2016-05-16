class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  validates :rating, :description, presence: true
  validate :valid_reservation?

  def valid_reservation?
  	unless !reservation.nil? && reservation.status == "accepted" && reservation.checkout < Date.today
  		errors.add(:invalid_res, "The guest must have accepted the reservation and checked out")
  	end
  end



end
