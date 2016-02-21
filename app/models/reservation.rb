class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence: true
  validate :host_and_guest_not_same
  validate :available
  validate :realtime
  validate :stay


  def duration
    checkout - checkin 
  end

  def total_price
    duration * self.listing.price
  end



    private


    def host_and_guest_not_same
      if listing.host_id == guest_id
        errors.add(:reservation, "you cannot book your own listing")
      end
    end

    def available
      other_reservations = self.listing.reservations
      check_in = self.checkin
      check_out = self.checkout

      if !check_in || !check_out
        return false
      end

      arr = other_reservations.select {|rez| (check_in..check_out).overlaps?(rez.checkin..rez.checkout)}

      if !arr.empty?
        errors.add(:reservation, "not available")
      end

    end

    def realtime

      if !self.checkin || !self.checkout
        return false
      end

      if self.checkin > self.checkout
        errors.add(:reservation, "You cannot checkout before checkin unless you travel through time.")
      end

    end

    def stay

      if !self.checkin || !self.checkout
        return false
      end

      if self.checkin == self.checkout
        errors.add(:reservation, "Does the listing say 'dead hooker storage'?")
      end
      
    end




end
