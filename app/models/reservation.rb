class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates_presence_of :checkin, :checkout
  validate :reservation_not_ownership, :available, :dates_ok


  def reservation_not_ownership
     if guest_id == listing.host_id
      errors.add(:guest_id, "You can't book your own apartment.")
    end
  end

  def available
        Reservation.all.each do |reservation|
          if self.listing_id == reservation.listing_id && self.id != reservation.id # is a record of the same listing but not the same entry, per its id
            if self.checkin && self.checkout # validates that there is data in the checkin and checkout fields
              if (self.checkin >= reservation.checkin && self.checkin <= reservation.checkout) ||
                (self.checkout <= reservation.checkout && self.checkout >= reservation.checkin)
              errors.add(:reservation, "The listing is not available.")
            end
          end
        end
      end
    end

    def dates_ok
      if self.checkin && self.checkout  # makes sure data is present
        if (self.checkin == self.checkout) || (self.checkin > self.checkout)  # invalid data test
          errors.add(:reservation, "Invalid reservation dates entered")
        end
      end
    end

    def duration 
      self.checkout - self.checkin
    end

    def total_price
      self.listing.price * self.duration
    end

end


# 1) Reservation reservation validations validates that a listing is available at checkin before making reservation
#      Failure/Error: expect(@invalid_checkin).to_not be_valid
#        expected #<Reservation id: nil, checkin: "2014-04-26", checkout: "2014-05-28", listing_id: 1, guest_id: 4, created_at: nil, updated_at: nil, status: "pending"> not to be valid
# #      # ./spec/models/reservation_spec.rb:57:in `block (3 levels) in <top (required)>'
# Reservation.create!(checkin: '2014-04-25', checkout: '2014-04-30', 
#   listing_id: 1, guest_id: 4, :status => "accepted")

# @invalid_checkin = Reservation.new(checkin: '2014-04-26', checkout: '2014-05-28', 
#   guest_id: User.find_by(id: 4).id, listing_id: Listing.first.id)