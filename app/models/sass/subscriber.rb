class Subscriber < ActiveRecord::Base
  establish_connection MOZART_SASS
  validates_presence_of(:name, :password, :domain)
end
