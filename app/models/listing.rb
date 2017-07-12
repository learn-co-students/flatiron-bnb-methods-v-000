class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :address, :listing_type, :title, :description, :price, :neighborhood, presence: true

  after_create :set_host

  before_destroy :unset_host, if: :last_listings?

  def average_review_rating
    sum = 0.0
    reviews.each{|x| sum += x.rating}
    ans = sum/reviews.count
  end

  def res_num
    reservations.count
  end

  def occupied?(start_date, end_date)
    !!reservations.detect{|x| x.occupied?(start_date, end_date)}
  end

  def set_host
    host.update(host: true)
  end

  def unset_host
    host.update(host: false)
  end

  def last_listings?
    host.listings.count == 1
  end
end
