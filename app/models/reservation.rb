class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates_presence_of :checkin, :checkout
  validate :guest_is_not_host
  validate :checkout_after_checkin
  # validate :listing_available

  def duration
    self.all_res_dates.count
  end

  def total_price
    self.price * self.duration
  end

  def all_res_dates
    (self.checkin..self.checkout).collect {|day| day}
  end

  # def listing_available
  #   self.all_res_dates.none? {|date| self.listing.dates_occupied.include?(date)}
  # end

private

  def guest_is_not_host
    guest_id != listing.host_id
  end

  def checkout_after_checkin
    checkin < checkout
  end

end
