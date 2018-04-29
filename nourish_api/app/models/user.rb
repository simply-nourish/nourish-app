class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # custom profile additions and validate password existence
  # associations, if any

  # validates values exist
  validates_presence_of :first_name, :last_name, :email, 
  :encrypted_password, :default_servings
end
