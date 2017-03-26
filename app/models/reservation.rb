class Reservation < ActiveRecord::Base
  belongs_to :listing, counter_cache: true
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates_presence_of :checkin, :checkout

  validate :reasonable_date_range, on: :create
  validate :is_not_host
  validate :doesnt_conflict
  validate :not_same_day

  def is_not_host
    if
      self.guest == self.listing.host
      self.errors.add(:base, "You can't reserve your own house!")
    end
  end

  def reasonable_date_range
    if self.checkout && self.checkin && (self.checkout < self.checkin)
        self.errors.add(:base, "Sorry, you can't go back in time while you stay here.")
    end
  end

  def doesnt_conflict
    if self.checkin != nil && self.checkout != nil
      self.listing.reservations.each do |res|
        if (self.checkin < res.checkout) && (self.checkout > res.checkin)
          self.errors.add(:base, "Sorry, these dates conflict with another guest's stay!")
        end
      end
    end
  end

  def not_same_day
    if self.checkin == self.checkout && self.checkin != nil
      self.errors.add(:base, "Check In and Check Out can't be on the same day!")
    end
  end

  def duration
    self.checkout-self.checkin
  end

  def total_price
    self.duration * self.listing.price
  end

end
