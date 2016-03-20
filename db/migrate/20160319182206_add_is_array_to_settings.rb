class AddIsArrayToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :is_array, :boolean
  end
end
