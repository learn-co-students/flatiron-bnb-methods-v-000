class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, class_name: 'User'
  has_many :reservations
  has_many :reviews, through: :reservations
  has_many :guests, class_name: 'User', through: :reservations

  validates :title, :description, :address, :listing_type, :price, :neighborhood, presence: true
  before_create :set_host_status
  after_destroy :reset_host_status

  def average_review_rating
    count = 0
    avg = 0
    reviews.each do |r|
      count += r.rating
      if reviews.count != 0
        avg = count/reviews.count.to_f
      end
    end
    avg
  end

  private

  def set_host_status
    @listing_status = User.find(host_id)
    @listing_status.host = true
    @listing_status.save
  end

  def reset_host_status
    @listing_status = User.find(host_id)
    if @listing_status.listings.count == 0
      @listing_status.host = false
      @listing_status.save
    end
  end
end
