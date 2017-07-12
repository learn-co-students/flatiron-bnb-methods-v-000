class AddNeighborhoodCountToCity < ActiveRecord::Migration
  def change
    add_column :cities, :neighborhoods_count, :integer
  end
end
