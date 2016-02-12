class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  validates :checkin, :checkout, presence: true
  validate :cant_make_reservation_on_own_listing
  # after_validation :reservation_conflict


  def duration
  	(checkout - checkin).floor
  end

  

  # def reservation_conflict
  # 	conflict = Reservation.all.detect do |reservation|
  # 		checkin == reservation.checkin || checkout == reservation.checkout
  # 	end
  # 	if !conflict.nil?
  # 		errors.add(:conflict, "Your reservation conlicts with someone else's")
  # 	end
  # end	

  private

  def cant_make_reservation_on_own_listing
  	if guest_id == listing.host_id
  		errors.add(:duplicate, "You can't make a reservation on your own listing")
  	end
  end

end
