class Listing < ActiveRecord::Base
  belongs_to :neighborhood, required: true #associated with neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :address, presence: true
  validates :description, presence: true
  validates :listing_type, presence: true
  validates :price, presence: true
  validates :title, presence: true
  validates :neighborhood_id, presence: true
  
  # before_save :
  #after_destroy :

end
