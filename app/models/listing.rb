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

  before_create :make_host
  after_destroy :change_host_when_destroyed



  def average_review_rating
    sum = 0.0
    self.reviews.each do |x|
      sum += x.rating
    end
    sum / self.reviews.count
  end


  private

  def make_host
    unless self.host.host
      self.host.update(:host => true)
    end
  end

  def change_host_when_destroyed
    if self.host.listings.present?
      make_host
    else
      self.host.update(:host => false)
    end
  end



end
