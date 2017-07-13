class Listing < ActiveRecord::Base
  validates :address, presence: true
  validates :listing_type, presence: true
  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true
  validates :neighborhood, presence: true
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  after_create :change_host
  after_destroy :change_host

  def average_review_rating
    total_reviews = self.reviews.count
    total_score = 0
    self.reviews.each do |x|
      total_score += x.rating
    end
    total_score.to_f / total_reviews
  end

  def change_host
    if self.host.listings.empty?
      self.host.update(host: false)
    else
      self.host.update(host: true)
    end
  end

  def available?(checkin, checkout)
    if self.reservations.any? {|x| checkin.to_date.between?(x.checkin, x.checkout) || checkout.to_date.between?(x.checkin, x.checkout)}
      false
    else
      true
    end
  end

  def availabilities(checkin, checkout)
    array = []
    self.reservations.each do |x|
      if checkin.to_date.between?(x.checkin, x.checkout) || checkout.to_date.between?(x.checkin, x.checkout)
      else
        array << x
      end
    end
    array
  end

end
