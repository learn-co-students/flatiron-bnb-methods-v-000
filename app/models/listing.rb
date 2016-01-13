# == Schema Information
#
# Table name: listings
#
#  id              :integer          not null, primary key
#  address         :string
#  listing_type    :string
#  title           :string
#  description     :text
#  price           :decimal(8, 2)
#  neighborhood_id :integer
#  host_id         :integer
#  created_at      :datetime
#  updated_at      :datetime
#

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
  validates :neighborhood, presence: true

  def self.available_from?(query_begin_date, query_end_date)
    reservations.booked.empty?
  end
end
