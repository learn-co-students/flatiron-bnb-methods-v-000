class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, presence: true
  validates :checkout, presence: true
  validate :cannot_reserve_own_listing, :checkin_before_checkout, :checkin_same_as_checkout, :listing_is_open_during_proposed_stay

  

  def cannot_reserve_own_listing
    if self.guest != nil && self.listing.host != nil
      if self.guest.id == self.listing.host.id
        errors.add(:invalid_guest_request, "cannot rent out own listing")
      end
    end
  end

  def checkin_before_checkout
    if self.checkin != nil && self.checkout != nil
      if self.checkin >= self.checkout
        errors.add(:invalid_dates, "cannot checkin after checkout")
      end
    end
  end

  def checkin_same_as_checkout
    if self.checkin.to_s != "" && self.checkout.to_s != ""
      if self.checkin == self.checkout
        errors.add(:invalid_stay_length, "must stay at least one night")
      end
    end
  end

   def listing_is_open_during_proposed_stay
    all_reservations = []

    Reservation.all.each do |reservation|
      all_reservations << reservation
    end
    # 2) keep only the reservations from that neighborhood
    if self.listing != nil
      all_reservations.keep_if{ |reservation| reservation.listing.id == self.listing.id}
    end

    if self.checkin.to_s != "" && self.checkout.to_s != ""
      all_reservations.each do |reservation|
        if !(reservation.checkin > self.checkout || reservation.checkout < self.checkin)
          errors.add(:checkin_times, "listing is booked during those time periods") unless self.id != nil
        end
      end
    end
  end




  #   if self.checkin.to_s != "" && self.checkout.to_s != ""
  #     self.listing.neighborhood.listings_not_available(self.checkin.to_s, self.checkout.to_s)
  #   end

  #   if @all_neighborhood_listings_in_date_range != nil
  #     @all_neighborhood_listings_in_date_range.each do |lisitng|
  #       if listing.checkin > self.checkout || listing.checkout < self.chec
  #         errors.add(:invalid_dates_for_listing, "listing not available during selected time period")
  #       end
  #     end
  #   end

  
  def duration
    self.checkout - self.checkin
  end

  def total_price
    self.duration * self.listing.price
  end

end
