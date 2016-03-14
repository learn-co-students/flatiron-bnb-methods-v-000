require 'pry'
class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence: true
  validate :invalid_same_ids 
  validate :checkin_presence 
  validate :checkout_presence 
  validate :invalid_checkin 
  validate :invalid_checkout 
  validate :invalid_same_checkout_checkin 
  validate :invalid_checkout_before_checkin 



  def invalid_same_ids
    # binding.pry
    if listing.host == guest
      errors.add(:guest, "Cannot make a reservation on you own listing.")
    end
  end

  def checkin_presence
    if checkin.nil?
      errors.add(:checkin, "Must give a checkin time.")
    end
  end

  def checkout_presence
    if checkout.nil?
      errors.add(:checkin, "Must give a checkin time.")
    end
  end

  def invalid_checkin
    if !checkin.nil?
      if !listing.available?(checkin) 
        errors.add(:checkin, "This listing is not available on that date")
      end
    else
      errors.add(:checkin, "Must give a checkin time.")
    end
  end

  def invalid_checkout
    if !checkout.nil?
      if !listing.available?(checkout)
        errors.add(:checkout, "This listing is not available on that date")
      end
    else
      errors.add(:checkout, "Must give a checkout time.")
    end
  end

  def invalid_checkin_checkout
    
  end

  def invalid_checkout_before_checkin
    if !checkin.nil? && !checkout.nil?
      if checkin > checkout
        errors.add(:checkout, "Checkout can't be before checkin")
      end
    else
      errors.add(:checkin, "Must give a checkin and checkout time.")
    end
  end

  def invalid_same_checkout_checkin

    if checkin == checkout
      errors.add(:checkout, "Checkout can't be same as checkin")
    end
  end


  def total_price
    listing.price * duration
  end


  def duration
    checkout - checkin
  end



end



