class AddDescriptionToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :description, :string, limit: 1000
  end
end
