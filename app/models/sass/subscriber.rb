class Subscriber < ActiveRecord::Base
  establish_connection MOZART_SASS
  # validates_presence_of(:name, :password, :domain)
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :confirmable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, password_length: 6..128
end
