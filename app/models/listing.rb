class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  
  validates :address, :listing_type, :title, :description, :price, :neighborhood_id, presence: true

 before_save :host_status_change
 before_destroy :host_status_e

  def average_review_rating
  	ratings = []
  	self.reviews.each do |x|
  		ratings << x.rating
  	end
  	ratings.reduce(:+).to_f/ratings.count
  end

  private
  
    def host_status_change
    	if self.host
    		self.host.host = true
    		self.host.save
		end
    end

    def host_status_e
    	if self.host.listings.count == 1
    		self.host.host = false
    		self.host.save
    	end
    end

end
