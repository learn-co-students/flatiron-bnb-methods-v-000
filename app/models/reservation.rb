class Reservation < ActiveRecord::Base
  belongs_to :listing, counter_cache: true
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates_presence_of :checkin, :checkout

  validate :is_not_host

  def is_not_host
    if
      self.guest == self.listing.host
      self.errors.add("You can't reserve your own house!")
    end
  end

  def duration
    self.checkout-self.checkin
  end

  def total_price
    self.duration * self.listing.price
  end

end
