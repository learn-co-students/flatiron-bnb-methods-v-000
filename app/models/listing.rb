class Listing < ActiveRecord::Base
  belongs_to :neighborhood, required: true
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, through: :reservations
  has_many :guests, class_name: "User", through: :reservations
  
  after_save :set_host_status
  before_destroy :destroy_host_status

  validates :address, presence: true
  validates :listing_type, presence: true
  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true
  # validates :neighborhood_id, presence: true
  
  def average_review_rating
    reviews.average(:rating)
  end


  private

  # def self.available(d1, d2)
  #   if d1 && d2
  #     joins(:reservations).where.not(reservations: {check_in: d1..d2}) & joins(:reservations).where.not(reservations: {check_out: d1..d2})
  #   else
  #     []
  #   end
  # end

  def set_host_status
    host.update(host: true)
  end

  def destroy_host_status
    if Listing.where(host: host).where.not(id: id).empty?
      host.update(host: false)
    end
  end

end
