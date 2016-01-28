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

  before_create :update_create
  before_destroy :update_destroy

  def average_review_rating
    avg = self.reviews.sum(:rating) / self.reviews.count.to_f
  end

  private
  
  def update_create
    self.host.update(host: true)
  end

  def update_destroy
    self.host.update(host: false) if self.host.listings.count == 1
  end
  
end
