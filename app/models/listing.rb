class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :address, :listing_type, :title, :description, :price, :neighborhood, presence: true

  after_create :change_host
  after_destroy :change_host

  def available?(checkin, checkout)
    unless self.reservations.any? { |r| checkin.to_date.between?(r.checkin, r.checkout) || checkout.to_date.between?(r.checkin, r.checkout)}
      true
    end
  end

  def average_review_rating
    stars = 0.0
    self.reviews.all.each do |review|
      stars += review.rating
    end
    stars / self.reviews.count
  end

  private

  def change_host
    if self.host.listings.empty?
      self.host.update(host: false)
    else
      self.host.update(host: true)
    end
  end

end
