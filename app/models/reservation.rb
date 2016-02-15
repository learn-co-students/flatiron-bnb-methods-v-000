class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_many :hosts, class_name: "User", through: :listing
  has_many :host_reviews, class_name: "Review"
  has_one :review
  validates :checkin, presence: true
  validates :checkout, presence: true
  validate :cant_make_reservation_on_own_listing
  validate :checkin_conflict


  def duration
  	(checkout - checkin).floor
  end

  def total_price
    listing.price * duration
  end

  
  def checkin_conflict
  	if !listing.nil? && listing.reservations.include?(checkin)
  		errors.add(:checkin_conflict, "There is already a booking at that time")
  	end
  end
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
