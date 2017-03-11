class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  def available?(start_date, end_date)
    start_date_parsed = Date.parse(start_date)
    end_date_parsed   = Date.parse(end_date)

    # a listing is available only if NONE of the associated reservations is on the queried time
  	self.reservations.none? do |reservation| 
  		(reservation.checkin <= end_date_parsed) && (reservation.checkout >= start_date_parsed)
  	end
  end

  def method_name
  	
  end


end
