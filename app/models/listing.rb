class Listing < ActiveRecord::Base
  validates :address, presence: true
  validates :listing_type, presence: true
  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true
  validates :neighborhood, presence: true
  after_destroy :host_or_guest?
  after_save :host_on 
 


  belongs_to :neighborhood
  has_one :city, through: :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  def host_on
    self.host.to_host
  end


  def host_or_guest?
    if self.host.listings.empty?
      self.host.to_guest
    end
  end


  def average_review_rating
    ratings = self.reviews.map{|rev| rev.rating}
    avg = (ratings.inject(0){|sum, x| sum + x} / ratings.length.to_f)
  end

  
end
