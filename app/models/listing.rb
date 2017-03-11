class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  

  private
  
  def self.available(start_date, end_date)
  	period = start_date..end_date
  	if start_date && end_date
  		no_checkin_in_period 	= self.joins(:reservations).where.not(reservations: {checkin: period})
  		no_checkout_in_period 	= self.joins(:reservations).where.not(reservations: {checkout: period})
  		no_checkin_in_period.merge(no_checkout_in_period)
  		# merge acts like AND
  	else
  		[]
  	end
  end



 #  def self.bookable(start_date, end_date)
 #  # v3 was
	# # if start_date && end_date
 #  #  	joins(:reservations).where.not(reservations: {checkin: start_date..end_date}) +
 #  #   joins(:reservations).where.not(reservations: {checkout: start_date..end_date})
 #  # else
 #  #   []
 #  # end
 #  # 
	# # v2 was
 # 	# period = start_date..end_date
	# # no_checkin_in_period = Reservation.where.not(checkin: period)
	# # no_checkout_in_period = Reservation.where.not(checkout: period)
	# # self.joins(:reservations).merge(no_checkin_in_period).merge(no_checkout_in_period)
	# #
	# # v1 was
	# # self.joins(:reservations).merge( Reservation.where.not("checkin <= ? AND checkout >= ?", end_date, start_date) )
	# # listings that have reservations, AND these reservations are not overlapping with the start and end date
 #  end
end
