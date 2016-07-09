class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates_presence_of :checkin, :checkout
  validate :checkin_checkout
  validate :not_your_own_listing
  validate :listing_available

  def duration
    self.checkout - self.checkin
  end

  def total_price
    self.duration * listing.price
  end

  private

  def not_your_own_listing
    if guest !=  listing.host 
    else
      errors.add(:base, "It's your home, fool!")
    end
  end

  def listing_available
    if listing.available?(checkin, checkout)
    else
      errors.add(:base, "Listing's not available!")
    end
  end

  def checkin_checkout
    if checkin && checkout && checkin != checkout && checkin < checkout
    else
      errors.add(:base, "Invalid check in and check out dates!")
    end
  end

end
