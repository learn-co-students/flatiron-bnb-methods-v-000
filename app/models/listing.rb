class Listing < ActiveRecord::Base

  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  
  before_create :set_host
  after_destroy :no_host

  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true
  validates :listing_type, presence: true
  validates :address, presence: true
  validates :neighborhood, presence: true

  def average_review_rating
  
    self.reviews.map {|review| review.rating}.inject(0){|sum, rating| sum + rating}.to_f / self.reviews.size
  end

  private

  def set_host
    self.host.update(:host => true)
  end

  def no_host
    self.host.update(:host => false) if self.host.listings.empty?
  end
end
