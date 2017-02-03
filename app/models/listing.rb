class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  validates :address, :listing_type, :title, :description, :price, presence: true 
  validates :neighborhood, presence: true
  before_save :change_host_status
 
	
	private

	def change_host_status
	 	self.host.host = true
	end 


end
