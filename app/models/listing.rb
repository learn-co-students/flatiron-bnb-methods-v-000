class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :address, :listing_type, :title, :description, :price, :neighborhood, presence: true

  after_create :change_host_status

  after_destroy :revert_host_status

  def average_review_rating
    ratings = self.reviews.collect do |r|
      r.rating
    end
    ratings.inject(0, :+).to_f / ratings.count
  end

  private
  def change_host_status
    if !self.host.host?
      self.host.update(host: true)
    end
  end

  def revert_host_status
    if self.host.listings == []
      self.host.update(host: false)
    end
  end
end
