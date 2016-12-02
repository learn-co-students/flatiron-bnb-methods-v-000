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
  before_create :make_host
  before_destroy :unmake_host
  


  def reservation_count
    self.reservations.count
  end

  def average_review_rating
    reviews.average(:rating)
  end

  private 

  def make_host
    if !self.host.host && !self.host.nil?
      self.host.update(host: true) 
    end
  end

  def unmake_host
    if !self.host.nil? && self.host.listings.size == 1
      host.update(host: false)
    end
  end


end
