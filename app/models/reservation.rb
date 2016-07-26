class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence: true

  validate :available,  :checkout_before_checkin, :the_same_address

  def duration
    (checkout - checkin).to_i
  end

  def total_price
    listing.price * duration
  end

  private


  def available
    #binding.pry
    Reservation.where(listing_id: listing.id).where.not(id: id).each do |r|
      if ((r.checkin...r.checkout) === checkin || (r.checkin...r.checkout) === checkout)
       errors.add(:guest_id, "Sorry, this place isn't available at this time.")
      end
     end
  end

 def the_same_address
    if guest_id == listing.host_id
     errors.add(:guest_id, "Sorry the address must be different.")
   end
 end

  def checkout_before_checkin
   if checkout && checkin && checkout <= checkin
     errors.add(:guest_id, "Your check-out date needs to be after your check-in.")
   end
  end

end
