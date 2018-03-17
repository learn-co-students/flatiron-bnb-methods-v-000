class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :address, :listing_type, :title, :description, :price, :neighborhood_id, presence: true

  before_save :change_host_status
  after_destroy :change_host_status_back

  def average_review_rating
    reviews = []

    self.reviews.each do |review|
      reviews << review.rating
    end
    reviews.inject {|sum, element| sum + element}.to_f/reviews.size
  end

  private

    def change_host_status
      self.host.update(host: true)
    end

    def change_host_status_back
      if self.host.listings.empty?
        self.host.update(host: false)
      end
    end

end
