class CreateDescription < ActiveRecord::Migration
  def change
    create_table :descriptions do |t|
      t.integer :hotel_id
      t.string :lang
      t.text :description
      t.belongs_to :hotel, index: true
    end
  end
end
