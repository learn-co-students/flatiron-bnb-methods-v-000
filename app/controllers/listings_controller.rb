class ListingsController < ApplicationController

  def new
    @post = Post.new
  end

  def create
    @listing = Listings.new
    @listing.save
    redirect_to post_path(@post)
  end
end
