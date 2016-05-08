class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  validates :address, presence: true
  validates :listing_type, presence: true
  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true
  validates :neighborhood, presence: true
  before_create :set_host_attribute
  after_destroy :reset_host_attribute


  def average_review_rating
  	self.reviews.all.inject(0) {|sum, hash| sum + hash[:rating]}/
  	self.reviews.all.inject(0) {|sum, hash| sum + 1}.to_d
  end

private

   def set_host_attribute
   	 @listing_host = User.find(self.host_id)
   	 @listing_host.host = true
   	 @listing_host.save
   end

   def reset_host_attribute
   	@listing_host = User.find(self.host_id)
   	if @listing_host.listings.count == 0 
   		@listing_host.host = false
   		@listing_host.save
   	end
   end
  
end
