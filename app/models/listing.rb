class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  validates_presence_of :address, :listing_type, :title, :description, :price, :neighborhood
  after_save :change_host_status_to_true
  before_destroy :change_host_status_to_false

  def average_review_rating
    total = 0
    count_of_reviews = 0
    reviews.each do |review|
      unless review.rating.nil?
        count_of_reviews += 1
        total += review.rating
      end
    end

    avg = total / count_of_reviews.to_f
  end
  
  private
  def change_host_status_to_true
    if host && !host.host
      host.update(:host => true)
    end
  end

  def change_host_status_to_false
    if host && host.host
      if host.listings.count == 1
        host.update(:host => false)
      end
    end
  end

  def self.available(start_date, end_date)
    if start_date && end_date
      joins(:reservations).
        where.not(reservations: {checkin: start_date..end_date}) &
      joins(:reservations).
        where.not(reservations: {checkout: start_date..end_date})
    else
      []
    end
  end
end
