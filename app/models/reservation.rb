class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  
  validates_presence_of :checkin, :checkout
  validate :invalid_res?, :valid_stay?, :res_not_avail?

  def duration
    @days = self.checkout - self.checkin
    @days.to_i
  end

  def total_price
    self.listing.price.to_f * self.duration
  end

  def invalid_res?
    if self.listing.host == self.guest
      errors.add(:host, "You can't make a reservation on your own listing foo!")
    end
  end

  def res_not_avail?
    if checkin && checkout && self.id.nil? && self.listing.reservations.any?
      self.listing.reservations.any? do |r|
        res = r.checkin.to_date..r.checkout.to_date
        your_res = checkin.to_date..checkout.to_date
        if res.include?(self.checkin.to_date) || res.include?(self.checkout.to_date)
          errors.add(:base, "Could not make reservation because listing is not available during selected checkin/checkout date.")
        elsif your_res.include?(r.checkin.to_date) || your_res.include?(r.checkout.to_date)
          errors.add(:base, "Could not make reservation because listing is not available during selected checkin/checkout date.")
        end
      end
    end
  end

  def valid_stay?
    if checkin && checkout && (self.duration < 1)
      errors.add(:base, "Checkin and checkout dates must be at least one day apart.")
    end
  end

end
