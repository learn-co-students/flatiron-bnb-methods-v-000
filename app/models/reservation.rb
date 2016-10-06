class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence: true
  validate :host_cannot_be_guest, :listing_available_at_checkin


  def host_cannot_be_guest
      if guest_id == listing.host_id
        errors.add(:guest_id, "host cannot reserve it's on listing")
      end
  end

  def listing_available_at_checkin
    # if the new checking and checkout dates is not the same as the checkin date of the user
    Reservation.all.inspect do |res|
     checkin_checkout_range = res.checkin..res.checkout
     if checkin_checkout_range == checkin || checkin_checkout_range == checkout
       errors.add(:guest_id, "this reservation has already been taken")
    end
    # if listing_id !=
    end
  end

end
