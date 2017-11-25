class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :address, :listing_type, :title, :description, :price, :neighborhood, presence: true
  after_create :change_host_status
  after_destroy :confirm_host_status

  def average_review_rating
    num_review = 0
    grade = 0.0
    self.reservations.each do |res|
      if res.review
        num_review += 1
        grade += res.review.rating
      end
    end
    grade / num_review
  end

  private

  def change_host_status
    self.host.host == true ? self.host.host = false : self.host.host = true
    self.host.save
  end

  def confirm_host_status
    if self.host.listings.empty? && self.host.host == true
      self.host.host = false
      self.host.save
    end
  end


end
