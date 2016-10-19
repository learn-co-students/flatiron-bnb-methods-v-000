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
  after_create :make_host
  after_destroy :remove_host

  def average_review_rating
    reviews = []
    reviews = self.reservations.collect { |res| res.review.rating }
    mean(reviews)
  end

  private

  def mean(array)
	  array.inject(0) { |sum, x| sum += x } / array.size.to_f
	end

  def make_host
    self.host.host = true
    self.host.save
  end

  def remove_host
    if self.host.listings.empty?
      self.host.host = false
      self.host.save
    end
  end

end
