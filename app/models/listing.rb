class Listing < ActiveRecord::Base
  belongs_to :neighborhood, required: true
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :address, presence: true
  validates :description, presence: true
  validates :listing_type, presence: true
  validates :price, presence: true
  validates :title, presence: true

  after_save :set_host, on: :create

  after_destroy :set_host

  def average_review_rating
    reviews.average(:rating)
  end

  private

  def set_host
    if self.host.listings.empty?
      self.host.update(host: false)
    else
      self.host.update(host: true)
    end
  end

  def self.available(start_date, end_date)
    if (start_date <= end_date && end_date >= start_date)
      joins(:reservations).
        where.not(reservations: {checkin: start_date..end_date}) &
      joins(:reservations).
        where.not(reservations: {checkout: start_date..end_date})
    else
      []
    end
  end

end
