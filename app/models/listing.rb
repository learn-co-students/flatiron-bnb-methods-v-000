class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :address, :listing_type, :title, :description, :price, :neighborhood, presence: true


  after_create :set_host_status
  after_destroy :unset_host_status

   def set_host_status
     self.host.update(host: true)
   end

   def unset_host_status
     self.host.update(host: false) if self.host.listings.empty?
   end

   def average_review_rating
     self.reviews.average(:rating).to_f
   end
end
