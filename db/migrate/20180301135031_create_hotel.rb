class CreateHotel < ActiveRecord::Migration
  def change
    create_table :hotels do |t|
      t.string :name
      t.string :country_code
      t.text :description
      t.decimal :average_price
      t.integer :views_count
    end
  end
end
