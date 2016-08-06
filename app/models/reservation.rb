class Reservation < ActiveRecord::Base
  validates :checkin, presence: true
  validates :checkout, presence: true
  validate :valid_dates?
  #after_create :accept

  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  def duration
    (self.checkout - self.checkin).to_i
  end

  def total_price
    total_price = (self.duration.to_i * self.listing.price.to_i)
  end

  # def accept
  #   self.status = "accepted"
  # end

  def valid_dates?
    if self.checkin && self.checkout
      if self.checkin >= self.checkout
        errors.add(:checkin, "Check-in cannot be the same day or later than checkout")
      elsif shared_listings != [] 
        shared_listings.each do |r|
          unless r.id == self.id
            if r.checkin == self.checkin 
              errors.add(:checkin, "Check-in date already taken")
            elsif r.checkout == self.checkout 
              errors.add(:checkout, "Check-out date already taken")
            elsif (self.checkin.between?(r.checkin, r.checkout)) ||  (self.checkout.between?(r.checkin, r.checkout))
              errors.add(:checkout, "Dates already taken")
            end
          end
        end # else self.status = "accepted"?
      end 
      shared_listings.clear
    end
  end

  def shared_listings
    @rez_list = []
    Reservation.all.each do |rez|
      if rez.listing == self.listing
        @rez_list << rez
      end
    end
    @rez_list
  end

end
