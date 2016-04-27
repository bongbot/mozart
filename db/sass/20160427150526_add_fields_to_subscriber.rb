class AddFieldsToSubscriber < ActiveRecord::Migration
  def connection
    ActiveRecord::Base.establish_connection(MOZART_SASS).connection
  end
  def change
    add_column :subscribers, :name, :string
    add_column :subscribers, :password, :string
    add_column :subscribers, :domain, :string
    add_column :subscribers, :description, :text
  end
end
