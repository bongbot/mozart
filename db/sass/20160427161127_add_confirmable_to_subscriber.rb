class AddConfirmableToSubscriber < ActiveRecord::Migration
  def connection
    ActiveRecord::Base.establish_connection(MOZART_SASS).connection
  end
  def change
    add_column :subscribers, :confirmation_token, :string
    add_column :subscribers, :confirmed_at, :datetime
    add_column :subscribers, :confirmation_sent_at, :datetime
    add_column :subscribers, :unconfirmed_email, :string
  end
end
