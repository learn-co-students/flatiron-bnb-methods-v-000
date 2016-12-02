class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, :description, :reservation, presence: true

  validate :associated_reservation_must_be_accepted_and_checked_out

  def associated_reservation_must_be_accepted_and_checked_out
  	#binding.pry
  	if !reservation.nil?
  	
	  	if Date.today < reservation.checkout
	  	 	errors.add(:reservation, "")
	  	end
	  end
  end


end
