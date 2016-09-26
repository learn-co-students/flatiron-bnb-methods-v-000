class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates_presence_of :checkin, :checkout

  validate :available, :guest_not_host

  def duration
    (checkout - checkin).to_i
  end

  def total_price
    self.listing.price * duration
  end

  private

  def available
    res = Reservation.where(listing_id: listing.id)
    if checkin && checkout
      # iterate through res and check if id = res.id?
      res.each do |r|
        if id == r.id
          break
        elsif checkin.between?(r.checkin, r.checkout) || checkout.between?(r.checkin, r.checkout)
          errors.add(:guest_id, "Sorry, this place isn't available during the date you specified.")
        elsif checkout <= checkin
          errors.add(:guest_id, "Checkin must be before checkout.")
        end
      end
    end

    # Reservation.where(listing_id: listing.id).where.not(id: id).each do |r|
    #   booked_dates = (r.checkin..r.checkout) # create range of booked dates
    #   if booked_dates === checkin || booked_dates === checkout # If checkin/checkout dates are within the range of booked dates
    #     errors.add(:guest_id, "Sorry, this place isn't available during the dates you specified.")
    #   end
    # end
  end

  def guest_not_host
    if guest_id == listing.host_id
      errors.add(:guest_id, "You can't book your own place.")
    end
  end

end
