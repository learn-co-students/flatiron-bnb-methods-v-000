class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :address, :listing_type, :title, :description, :price, :neighborhood, presence: true



  before_create :update_host_status
  after_destroy :host_status_to_false

  def update_host_status
    self.host.update(host: true)
  end

  def host_status_to_false
    if self.host.listings.empty?
      self.host.update(host: false)
    end
  end

  def average_review_rating
    ratings = []

    self.reviews.each do |review|
      ratings << review.rating
    end

    ratings.inject {|sum, n| sum + n}.to_f / ratings.count
  end



end
