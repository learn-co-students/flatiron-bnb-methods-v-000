class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, presence: true
  validates :checkout, presence: true
  validate :self_res
  validate :check_availability
  validate :checkin_before_checkout

  def duration
  	(checkout - checkin).to_f
  end

  def total_price
  	(listing.price * duration).to_f
  end

  def self_res
  	if self.guest == self.listing.host
  		errors.add(:guest, "You can't reserve your own listing")
  	end
  end

  def check_availability
  	listing.reservations.each do |r|
  		dates_taken = (r.checkin..r.checkout)
  		if dates_taken === checkin || dates_taken === checkout
  			errors.add(:guest_id, "Unavailable.")
  		end
  	end
  end

  def checkin_before_checkout
  	if (checkin.present? && checkout.present?) && checkin >= checkout
  		errors.add(:guest_id, "You can't checkout before you check it bub")
  	end
  end
end
