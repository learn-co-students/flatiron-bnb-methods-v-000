class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence: true
  validate :own_listing
  validate :check_availability
  validate :checkin_before_checkout

  def duration
    (checkout- checkin).to_i
  end

  def total_price
    self.duration * self.listing.price
  end

  private

  def own_listing
    if self.guest == self.listing.host
      errors.add(:guest, "You can't reserve your own listing.")
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
      errors.add(:guest_id, "You must checkin before you checkout")
    end
  end

end
