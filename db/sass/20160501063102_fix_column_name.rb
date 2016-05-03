class FixColumnName < ActiveRecord::Migration
  def connection
    ActiveRecord::Base.establish_connection(MOZART_SASS).connection
  end
  def change
    rename_column :subscribers, :password, :pwd
  end
end
