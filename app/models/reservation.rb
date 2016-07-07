class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  before_validation :cannot_make_a_reservation_on_your_own_listing
  validates :checkin, :checkout, presence: true

  validate :check_if_listing_is_avaliable_before_making_a_reservation

  
  def cannot_make_a_reservation_on_your_own_listing
    self.listing.host != self.guest 
  end

  def check_if_listing_is_avaliable_before_making_a_reservation
    checkin_time = self.checkin
    checkout_time = self.checkout
    @listing = Listing.find(self.listing_id)
   
    @listing.reservations.each do |reservation|
    !(reservation.checkin..reservation.checkout).include?(checkin_time) && !(reservation.checkin..reservation.checkout).include?(checkout_time)
    end
  end

    #r = Reservation.where(:checkin => checkin_time..checkout_time).pluck(:listing_id)
   # r2 = Reservation.where(:checkout => checkin_time..checkout_time).pluck(:listing_id)
   # listing_id_array = (r + r2).uniq
   # !listing_id_array.include?(self.listing.id)
  #end
 

 end
