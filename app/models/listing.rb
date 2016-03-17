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
  validates :neighborhood_id, :presence => true

  before_save :change_host_true
  before_destroy :change_host_false

  def change_host_true
    self.host.update(host: true)
  end

  def change_host_false
    unless self.host.listings.count > 1
      self.host.update( host: false)
    end
  end

  def average_review_rating
    count = 0
    output = "you can't divide by 0"
    self.reviews.each do |review|
      count += review.rating
      unless self.reviews.count == 0
        output = count/self.reviews.count.to_f
      end
    end
    output
  end

end
