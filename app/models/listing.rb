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
  after_destroy :no_longer_host

  def host_status
    user = User.find(host_id)
    user.host = true
    user.save
  end

  def no_longer_host
    user = User.find(host_id)
    if user.listings.size < 1
      user.host = false
      user.save
    end
  end

  def average_review_rating

    collected_score = []
    self.reviews.each do |review|
      collected_score << review.rating
    end

    collected_score.inject{ |sum, x| sum + x }.to_f / self.reviews.size
  end

end
