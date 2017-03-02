class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :address, :listing_type, :title, :description, :price, :neighborhood, presence: true

  after_save do
    host.update(host: true)
  end

  after_destroy do
    if host.listings == []
      host.update(host: false)
    end
  end

  def average_review_rating
    reviews.average(:rating)
  end

  def booked_dates
    reservations.collect { |res| (res.checkin..res.checkout).to_a}.flatten.uniq
  end

end
