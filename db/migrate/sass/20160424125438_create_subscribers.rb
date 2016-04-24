class CreateSubscribers < ActiveRecord::Migration
  def change
    create_table :subscribers do |t|
      t.string :name
      t.string :password
      t.string :domain
      t.text :description

      t.timestamps null: false
    end
  end
end
