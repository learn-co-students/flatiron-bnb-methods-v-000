class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  has_one :host, through: :listing

  validates_presence_of :checkin, :checkout
  validate :guest_is_not_host
  validate :checkout_after_checkin
  validate :listing_available

  def duration
    self.all_res_dates.count
  end

  def total_price
    self.listing.price * self.duration
  end

  def all_res_dates
    if checkin && checkout
      (checkin...checkout).collect {|day| day}
    end
  end

  def listing_available
    if checkin && checkout
      if !self.listing.neighborhood.neighborhood_openings(checkin.to_s, checkout.to_s).include?(self.listing)
        errors.add(:listing, "is not available")
      end
    end
  end

private

  def guest_is_not_host
    if guest && host.id == guest.id
      errors.add(:guest, "cannot be the same as host")
    end
  end

  def checkout_after_checkin
    if checkin && checkout
      if checkin > checkout || checkin == checkout
        errors.add(:checkin, "must be before checkout date")
      end
    end
  end

end
