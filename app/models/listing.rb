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
  after_save :activate_host
  after_destroy :inactivate_host
  
  def average_review_rating
    self.reviews.average("rating")
  end

  private

  def activate_host
    unless host == false
     host.update(host: true)
   end
  end

  # Use AR query to select listings that match id of host
  def inactivate_host
    if Listing.where(host: host).where.not(id: id).empty? 
      host.update(host: false)
    end
  end
end
