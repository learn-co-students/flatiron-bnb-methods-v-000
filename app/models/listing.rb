class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  validates_presence_of :address, :listing_type, :title, :description, :price, :neighborhood

  before_save :make_host
  before_destroy :change_host_status

  def average_review_rating
    reviews.average(:rating)
  end

  private
  def make_host
    unless self.host.host
      self.host.host = !self.host.host
      self.host.save
    end
  end

  def change_host_status
    if self.host.listings.count <= 1
      self.host.host = false
      self.host.save
    end
  end
end


# Better solutions. My code wasn't passing due to not saving. But it was working. Added .save and tests passed. Should have used .update.

# unless self.host.host
#   self.host.update(:host => true)
# end
