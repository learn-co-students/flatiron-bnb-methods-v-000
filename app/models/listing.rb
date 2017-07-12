class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  validates :address, presence: true
  validates :listing_type, presence: true
  validates :title, presence: true
  validates :description, :price, :neighborhood, presence: true

  before_create :host_status_true
  after_destroy :host_status_false

  def host_status_true
    self.host.host = true
    self.host.save
  end

  def host_status_false
    self.host.host = false if self.host.listings.empty?
    self.host.save
  end



  def average_review_rating
    self.reviews.average('rating').to_f
  end


end
