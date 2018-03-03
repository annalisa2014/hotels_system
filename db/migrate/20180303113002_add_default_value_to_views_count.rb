class AddDefaultValueToViewsCount < ActiveRecord::Migration
  def change
    change_column :hotels, :views_count, :integer, default: 0
  end
end
