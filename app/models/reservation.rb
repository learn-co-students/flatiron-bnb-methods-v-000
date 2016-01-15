class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates_presence_of :checkin, :checkout
  validate :guest_and_host_not_the_same_person
  validate :listing_is_available

  private

    def guest_and_host_not_the_same_person
      if self.listing.host_id == self.guest_id
        errors.add(:same_person, "can't reserve your own listing")
      end
    end

    def listing_is_available
      if !self.checkin.nil? && !self.checkout.nil?
        self.listing.reservations.each do |r|
          if self.checkin.between?(r.checkin,r.checkout) && self.checkout.between?(r.checkin,r.checkout)
            errors.add(:not_available, "these dates are not available")
          end
        end
      end
    end

end
