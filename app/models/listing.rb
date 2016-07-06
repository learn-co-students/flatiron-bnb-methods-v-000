class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  

  validates :address, :listing_type, :title, :description, :price, :neighborhood_id, presence: true


  def self.available(checkin_date, checkout_date)
    if checkin_date && checkout_date
      joins(:reservations).where.not(reservations:{checkin: ((checkin_date.to_datetime)..(checkout_date.to_datetime))}) & joins(:reservations).where.not(reservations:{checkout: ((checkin_date.to_datetime)..(checkout_date.to_datetime))})
      else
      []
    end
  end

#where not the argument checkin is between the reservations checkin and checkout

  private

  def host_status_change_to_true
    self.host.host = true
  end

  def host_status_change_to_false
    self.host.host = false 
  end

  end



  #Listing1 - Has a re 5/2-5/8 
  #5/1-5/5