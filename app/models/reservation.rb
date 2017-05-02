class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates_presence_of :checkin, :checkout
  validate :different_ids
  validate :unoccupied
  validate :date_order

  def different_ids
  	if guest == listing.host
  		errors.add(:different_ids, "You can't make a reservation in your own listing")
  	end
  end

  def unoccupied
    if checkin && checkout
    	self.listing.reservations.each do |res|
    		if (res.checkin <= checkin && res.checkout >= checkin) || (res.checkin <= checkout && res.checkout >= checkout)
    			errors.add(:unoccupied, "This listing is occupied durring that time")
    		end
    	end
    end
  end

  def date_order
    if checkin && checkout
    	if checkin >= checkout
    		errors.add(:date_order, "Checkin must be before checkout")
    	end
    end
  end

  def duration
    if checkin && checkout
  		checkout.day - checkin.day
    end
  end

  def total_price
  	self.listing.price * self.duration
  end
end
