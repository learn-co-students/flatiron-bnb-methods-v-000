class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence: true
  validates :checkin, :checkout, uniqueness: true

  validates_associated :listing, absence: true
  validate :check_availablity, :check_checkin_and_checkout, :checkin_before_checkout


  def check_availablity
   Reservation.where(listing_id: listing.id).where.not(id: id).each do |r|
     booked_dates = r.checkin..r.checkout
       if booked_dates === checkin || booked_dates === checkout
         errors.add(:guest_id, "Sorry, this place isn't available during your requested dates.")
       end
     end
  end

  def check_checkin_and_checkout
    errors.add(:checkout, "can't be the same as checkin date") if checkin == checkout

  end

  def duration
    (checkin..checkout).count-1
  end

  def total_price
    (listing.price).to_f * duration
  end

  def checkin_before_checkout
    errors.add(:checkin, "checkin date must be before checkout date") if checkout && checkin && checkout < checkin
  end

end
