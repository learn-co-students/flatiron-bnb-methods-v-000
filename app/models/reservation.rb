class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  include Concerns::Searchable
  
  def duration 
    if self.checkin && self.checkout 
      (self.checkout - self.checkin).to_i
    end
  end
  
  def total_price 
    if self.listing && self.checkin && self.checkout 
      self.listing.price.to_f * self.duration.to_i
    end
  end


  ### Validations ###
  
  class CircularValidator < ActiveModel::Validator 
    def validate(record)
      if record.listing.host == record.guest
        record.errors[:listing_id] << "Guest cannot make a reservation at their own listing"
      end
    end
  end
  
  class CheckinCheckoutValidator < ActiveModel::Validator 
    def validate(record)
      if record.listing && record.checkin && record.checkout
        if record.checkin == record.checkout 
          record.errors[:checkin] << "Checkin and Checkout Date cannot be the same"
        end
        if record.checkin > record.checkout 
          record.errors[:checkin] << "Checkin Date must be before Checkout Date"
        end
        if record.listing_available?(record.listing, record.checkin, record.checkout) == false
          record.errors[:checkin] << "This listing is not available for those dates."
        end
      end
    end
  end
  
  validates :checkin, presence: true
  validates :checkout, presence: true
  validates :listing_id, presence: true
  
  validates_with CircularValidator
  validates_with CheckinCheckoutValidator
end
