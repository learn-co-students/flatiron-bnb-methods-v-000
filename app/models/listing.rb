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

  after_save :set_host_as_host
  before_destroy :unset_host_as_host

  def average_review_rating
    reviews.average(:rating)
  end

  private

  def self.available(start_date, end_date)
    if start_date && end_date
      joins(:reservations).
        where.not(reservations: {check_in: start_date..end_date}) &
      joins(:reservations).
        where.not(reservations: {check_out: start_date..end_date})
    else
      []
    end
  end


  # it feels to me like part of what makes this complicated is
  # that we have column in the database called is_host,
  # but instead this could just be a method, and then rely on that..
  # not sure if it's worth the effort though.
  def unset_host_as_host
    # remove .id
    if Listing.where(host: host).where.not(id: id).empty?
      host.update(is_host: false)
    end
  end

  def set_host_as_host
    unless host.is_host?
      host.update(is_host: true)
    end
  end

  ## my solution ##
  # belongs_to :neighborhood
  # belongs_to :host, :class_name => "User"
  # has_many :reservations
  # has_many :reviews, :through => :reservations
  # has_many :guests, :class_name => "User", :through => :reservations
  #
  # validates :address, presence: true
  # validates :listing_type, presence: true
  # validates :title, presence: true
  # validates :description, presence: true
  # validates :price, presence: true
  # validates :neighborhood_id, presence: true
  #
  # after_create :set_user_host
  # after_destroy :set_user_false
  #
  # def average_review_rating
  #   reviews = self.reservations.collect do |res|
  #     res.review.rating
  #   end
  #   reviews.sum.to_f / reviews.size
  # end
  #
  # private
  #
  # def set_user_host
  #   User.find(self.host_id).update(host: true)
  # end
  #
  # def set_user_false
  #   User.find(self.host_id).update(host: false) if User.find(self.host_id).listings.empty?
  # end

end
