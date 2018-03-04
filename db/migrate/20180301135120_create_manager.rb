class CreateManager < ActiveRecord::Migration
  def change
    create_table :managers do |t|
      t.integer :user_id
      t.integer :hotel_id
      t.index [:user_id, :hotel_id]
      t.index [:hotel_id, :user_id]
    end
  end
end
