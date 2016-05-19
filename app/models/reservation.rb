class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, presence: true
  validates :checkout, presence: true
  validate :checkin_before_checkout
  validate :checkin_date_is_not_booked
  validate :checkout_date_is_not_booked
  validate :cannot_host_self



  def duration
    (checkin...checkout).count
  end

  def total_price
    (listing.price) * (duration)
  end


  def checkin_before_checkout
    unless checkin.nil? || checkout.nil?
      unless checkout > checkin
        errors.add(:checkout, 'is too early for that checkin date')
      end
    end
  end

  def checkout_date_is_not_booked
    booked = listing.reservations.any? do |res|
      dates = (res.checkin..res.checkout)
      dates.include?(self.checkout)
    end

    if booked
      errors.add(:checkout, 'is booked at for this listing already.')
    end
  end


  def checkin_date_is_not_booked
    booked = listing.reservations.any? do |res|
      dates = (res.checkin..res.checkout)
      dates.include?(self.checkin)
    end

    if booked
      errors.add(:checkin, 'is booked at for this listing already.')
    end
  end

  def cannot_host_self
    the_host = listing.host
    the_guest = self.guest

    if the_host == the_guest
      errors.add(:guest, 'cannot host themselves.')
    end
  end
end
