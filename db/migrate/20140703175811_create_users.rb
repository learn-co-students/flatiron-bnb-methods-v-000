class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.boolean :host, default: false
      t.timestamps null: false
    end
  end
end
