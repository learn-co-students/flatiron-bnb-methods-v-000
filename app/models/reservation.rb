class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, presence: true
  validates :checkout, presence: true


  validate :not_the_same_person
    validate :listing_is_available
    validate :date_order

    def duration
      self.checkout - self.checkin
    end

    def total_price
      duration * self.listing.price
    end

    private

      def not_the_same_person
        if self.listing.host_id == self.guest_id
          errors.add(:same_person, "can't reserve your own listing")
        end
      end

      def listing_is_available
        if !self.checkin.nil? && !self.checkout.nil?

          listing.reservations.each do |r|
            booked = (r.checkin..r.checkout)
            if booked === self.checkin || booked === self.checkout
              errors.add(:guest_id, "these dates are not available")
            end
          end
        end
      end

      def date_order
        if self.checkin && self.checkout
          if self.checkout <= self.checkin
            errors.add(:guest_id, "Your check-in is before your check-out")
          end
        end
      end








end
