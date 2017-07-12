class Listing < ActiveRecord::Base
  validates :address, presence: true 
  validates :listing_type , presence: true 
  validates :title , presence: true
  validates :description, presence: true 
  validates :price, presence: true
  validates :neighborhood_id, presence: true
  
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  after_create :host_status
  after_destroy :host_status

  def host_status
    if host.listings.empty?
      host.update(host: false)
    else
      host.update(host: true)
    end
  end

  def average_review_rating  
    reviews.average(:rating)
  end 
end
