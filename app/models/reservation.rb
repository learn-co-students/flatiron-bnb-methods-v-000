class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence: true
  validate :same_user, :occupied, :out_after_in


  def same_user
    if guest == listing.host
      errors.add(:guest, "can't be the same user as host")
    end
  end

  def occupied
    if !checkin.nil? && !checkout.nil?
      if listing.occupied?(checkin, checkout)
        errors.add(:listing, "not be available at that day")
      end
    end
  end

  def out_after_in
    if !checkin.nil? && !checkout.nil?
      if checkin >= checkout
        errors.add(:checkout, "can't be before checkin")
      end
    end
  end

  def duration
    (checkout.to_date - checkin.to_date).to_i
  end

  def total_price
    listing.price * duration
  end

  def occupied?(start_date, end_date)
    checkin < end_date.to_date && checkout > start_date.to_date
  end
end
