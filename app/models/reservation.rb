class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence: true
  validate :host_is_not_guest, :available_checkin, :available_checkout, :sensible_times


  def duration
    duration = checkout.to_date - checkin.to_date
    duration.to_i
  end

  def total_price
    total_price = listing.price * duration
    total_price.to_f
  end

  private
    def host_is_not_guest
      if guest == listing.host
        errors.add(:guest_id, "you cannot make a reservation on your own listing")
      end
    end

    def available_checkin
      if id.nil?
        id_for_lookup = 0
      else 
        id_for_lookup = id
      end
      bad_checkin_times = listing.reservations.where("checkin <= ? AND checkout >= ? AND id != ?", checkin, checkin, id_for_lookup)
      if !bad_checkin_times.empty?  
        errors.add(:checkin, "listing must be available at checkin")
      end
    end

    def available_checkout
      if id.nil?
        id_for_lookup = 0
      else 
        id_for_lookup = id
      end
      bad_checkout_times = listing.reservations.where("checkout >= ? AND checkin <= ? AND id != ?", checkout, checkout, id_for_lookup)
      if !bad_checkout_times.empty?
        errors.add(:checkout, "listing must be available at checkout")
      end
    end

    def sensible_times
      return if errors[:checkin].present? || errors[:checkout].present? # cannot rely on builtin validations to be performed in order
      if checkin >= checkout
        errors.add(:checkin, "checkin time must be before checkout time")
      end
    end

end
