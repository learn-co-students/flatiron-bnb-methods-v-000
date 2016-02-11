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
  validates :neighborhood_id, presence: true 

  before_save :host_status
  after_destroy :destroy_status

  def average_review_rating
    array = []
    reviews.each do |x|
      array << x.rating 
    end
    array.sum/array.size.to_f
  end

  private 

  def host_status
    user = self.host
    user.update(host: true)
  end

  def destroy_status
    user = self.host
    if user.listings.count == 0
      user.update(host: false)
    end
  end


  






end ## class end
