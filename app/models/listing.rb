class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  validates :address, :title, :listing_type, :description, :price, :neighborhood, presence: true
  before_create :change_user_to_host
  before_destroy :update_host_status

 def average_review_rating
  	reviews.average(:rating)
 end


 private  

  def change_user_to_host
  	if !host.nil? && host.host == false
  		host.update(host: true)
  	end
  end

  def update_host_status
  	if !host.nil? && host.listings.size == 1
  		host.update(host: false)
  	end
  end

  
end
