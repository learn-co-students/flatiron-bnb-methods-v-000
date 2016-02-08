class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence: :true

  validate :not_host, :listing_available, :valid_dates


  def duration
    (self.checkout - self.checkin).to_i
  end  

  def total_price
    self.listing.price * duration
  end  


  private

    def not_host
      if self.guest_id == listing.host_id
        errors.add(:not_host, 'You can not reserve your own listing')
      end  
    end

    def listing_available
      self.listing.reservations.each do |r|
        existing_dates = r.checkin..r.checkout
        if existing_dates.include?(self.checkin) || existing_dates.include?(self.checkout)
         errors.add(:listing_available, 'Listing is not available for your dates')
        end 
      end
    end

    def valid_dates
      if self.checkin && self.checkout  
        if self.checkin >= self.checkout
          errors.add(:valid_dates, 'Check-out is before check-in')
        end  
      end  
    end  
end
