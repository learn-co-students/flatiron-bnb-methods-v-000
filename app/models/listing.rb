class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  
  validates_presence_of :address, :listing_type, :price, :title, :description, :neighborhood

  after_create do
    User.find(host_id).update_host_status
  end

  after_destroy do
    User.find(host_id).update_host_status
  end
  
  def available?(start_date, end_date)
    reservations.where('checkin <= ? AND checkout >= ?', end_date, start_date).empty?
  end
  
  def average_review_rating
    reviews.average(:rating)
  end
end
