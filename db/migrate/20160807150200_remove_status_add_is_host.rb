class RemoveStatusAddIsHost < ActiveRecord::Migration
  def change
    add_column :users, :is_host, :boolean, default: false
    remove_column :users, :host
  end
end
