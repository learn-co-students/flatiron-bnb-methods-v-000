class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  before_validation :cannot_make_a_reservation_on_your_own_listing
  validates :checkin, :checkout, presence: true

  before_create :check_if_listing_is_avaliable_before_making_a_reservation

  
  def cannot_make_a_reservation_on_your_own_listing
    self.listing.host != self.guest 
  end

  def check_if_listing_is_avaliable_before_making_a_reservation
    checkin_time = self.checkin
    checkout_time = self.checkout
    r = Reservation.where(:checkin => checkin_time..checkout_time).pluck(:listing_id)
    r2 = Reservation.where(:checkout => checkin_time..checkout_time).pluck(:listing_id)
    listing_id_array = (r + r2).uniq
    !listing_id_array.include?(self.listing.id)
  end

#def self.available(checkin_date, checkout_date)
 #   if checkin_date && checkout_date
  #  r = Reservation.where(:checkin => checkin_date..checkout_date).pluck(:listing_id)
 #     r2 = Reservation.where(:checkout => checkin_date..checkout_date).pluck(:listing_id)
  #    where("id not in (?)", r+r2)
  #    else
 #     []
 #   end
 

 end