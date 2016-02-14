class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  belongs_to :host, :class_name => "User"
  has_one :review
  validates :checkin, presence: true
  validates :checkout, presence: true
  validate :cant_make_reservation_on_own_listing
  # validate :reservation_conflict


  def duration
  	(checkout - checkin).floor
  end

  
  # def checkin_conflict
  # 	if !listing.nil? && listing.reservations.include?(checkin)
  # 		false
  # 	end
  # end
  # def reservation_conflict
  # 	if !listing.nil?
  # 		conflict = listing.reservations.detect do |reservation|
  # 			checkin == reservation.checkin || checkout == reservation.checkout
  # 		end
  # 		if !conflict.nil?
  # 			errors.add(:conflict, "Your reservation conlicts with someone else's")
  # 		end
  # 	end
  # end	

  private

  def cant_make_reservation_on_own_listing
  	if guest_id == listing.host_id
  		errors.add(:duplicate, "You can't make a reservation on your own listing")
  	end
  end

end
