class Reservation < ActiveRecord::Base
  validates :checkin, presence: true
  validates :checkout, presence: true
  validate :valid_dates?


  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  def duration
    (self.checkout - self.checkin).to_i
  end

  def total_price
    total_price = (self.duration.to_i * self.listing.price.to_i)
  end



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

#Official solution:

# class Reservation < ActiveRecord::Base
#   belongs_to :listing
#   belongs_to :guest, :class_name => "User"

#   has_one :review

#   validates :check_in, :check_out, presence: true
#   validate :available, :check_out_after_check_in, :guest_and_host_not_the_same

#   def duration
#     (check_out - check_in).to_i
#   end

#   def total_price
#     listing.price * duration
#   end

#   private
  

#   def available
#     Reservation.where(listing_id: listing.id).where.not(id: id).each do |r|
#       booked_dates = r.check_in..r.check_out
#       if booked_dates === check_in || booked_dates === check_out
#         errors.add(:guest_id, "Sorry, this place isn't available during your requested dates.")
#       end
#     end
#   end

#   def guest_and_host_not_the_same
#     if guest_id == listing.host_id
#       errors.add(:guest_id, "You can't book your own apartment.")
#     end
#   end

#   def check_out_after_check_in
#     if check_out && check_in && check_out <= check_in
#       errors.add(:guest_id, "Your check-out date needs to be after your check-in.")
#     end
#   end
# end