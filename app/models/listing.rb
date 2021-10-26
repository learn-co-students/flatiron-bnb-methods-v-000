class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :title, presence: true
  validates :description, presence: true
  validates :address, presence: true
  validates :price, presence: true
  validates :listing_type, presence: true
  validates :neighborhood_id, presence: true

  after_create do
    host.update(host: true)
  end
  
  after_destroy do
    if host.listings.length==0 then host.update(host: false) end
  end

  def average_review_rating
    sum=0.0
    count=0
    reviews.each do |r|
      sum+=r.rating
      count+=1
    end
    sum/count
  end
end
