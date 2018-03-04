class RemoveDescriptionFromHotels < ActiveRecord::Migration
  def change
    remove_column :hotels, :description, :string
  end
end
