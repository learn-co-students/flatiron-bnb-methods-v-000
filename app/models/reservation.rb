class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence:true
  validate :dates, :hosts, :list

  def duration
    checkout - checkin
  end

  def total_price
    listing.price * duration
  end

  def dates
    if checkin && checkout
      if checkin >= checkout
        errors.add(:checkout, "checkout first")
      end
    end
  end

  def hosts
    if self.guest_id == listing.host_id
      errors.add(:reservation, "Cannot reserve")
    end
  end

  def list
    listing.reservations.each do |reserve|
      dates = reserve.checkin..reserve.checkout
      if dates.include?(self.checkin) || dates.include?(self.checkout)
        errors.add(:guest_id, "not on the list")
      end
    end
  end

end